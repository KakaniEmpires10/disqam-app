import { relations, sql } from 'drizzle-orm'
import { boolean, check, date, index, integer, pgTable, primaryKey, smallint, text, time, timestamp, uniqueIndex, uuid, varchar } from 'drizzle-orm/pg-core'

const timestamps = () => ({
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull().$onUpdate(() => new Date())
})

// Short pseudonymous identifier. Cross-device access uses a longer access code whose hash is stored separately.
export const participants = pgTable('participants', {
  id: uuid('id').defaultRandom().primaryKey(),
  code: varchar('code', { length: 32 }).notNull(),
  initials: varchar('initials', { length: 10 }).notNull(),
  ageAtEnrollment: smallint('age_at_enrollment'),
  gender: varchar('gender', { length: 16 }),
  // Hash of a secret retry key, never a public identifier. Nullable for legacy rows.
  registrationKeyHash: varchar('registration_key_hash', { length: 64 }),
  accessCodeHash: varchar('access_code_hash', { length: 64 }),
  ...timestamps()
}, table => [
  uniqueIndex('participants_code_uidx').on(table.code),
  uniqueIndex('participants_registration_key_uidx').on(table.registrationKeyHash),
  uniqueIndex('participants_access_code_uidx').on(table.accessCodeHash),
  check('participants_registration_hash_format', sql`${table.registrationKeyHash} ~ '^[0-9a-f]{64}$'`),
  check('participants_access_code_hash_format', sql`${table.accessCodeHash} ~ '^[0-9a-f]{64}$'`),
  index('participants_created_at_idx').on(table.createdAt),
  check('participants_code_format', sql`${table.code} ~ '^DQ-[A-HJ-NP-Z2-9]{8,16}$'`),
  check('participants_initials_not_blank', sql`length(btrim(${table.initials})) > 0`),
  // Technical bounds only, not eligibility criteria for the program.
  check('participants_age_range', sql`${table.ageAtEnrollment} between 0 and 130`),
  check('participants_gender_values', sql`${table.gender} in ('male', 'female', 'unspecified')`)
])

// Store SHA-256 of a high-entropy opaque token, never the raw access token.
export const participantSessions = pgTable('participant_sessions', {
  tokenHash: varchar('token_hash', { length: 64 }).primaryKey(),
  participantId: uuid('participant_id').notNull().references(() => participants.id, { onDelete: 'cascade' }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  revokedAt: timestamp('revoked_at', { withTimezone: true })
}, table => [
  index('participant_sessions_participant_idx').on(table.participantId),
  index('participant_sessions_expires_at_idx').on(table.expiresAt),
  check('participant_sessions_hash_format', sql`${table.tokenHash} ~ '^[0-9a-f]{64}$'`),
  check('participant_sessions_expiry', sql`${table.expiresAt} > ${table.createdAt}`)
])

// Raw wall-clock observations; no derived sleep score or clinical thresholds.
// Date convention and missing-value rules must be agreed before a write API.
export const sleepDiaries = pgTable('sleep_diaries', {
  id: uuid('id').defaultRandom().primaryKey(),
  participantId: uuid('participant_id').notNull().references(() => participants.id, { onDelete: 'restrict' }),
  sleepDate: date('sleep_date', { mode: 'string' }).notNull(),
  bedTime: time('bed_time', { precision: 0 }).notNull(),
  sleepStartTime: time('sleep_start_time', { precision: 0 }),
  nightAwakenings: integer('night_awakenings'),
  totalAwakeMinutes: integer('total_awake_minutes'),
  finalWakeTime: time('final_wake_time', { precision: 0 }).notNull(),
  outOfBedTime: time('out_of_bed_time', { precision: 0 }).notNull(),
  napMinutes: integer('nap_minutes'),
  ...timestamps()
}, table => [
  uniqueIndex('sleep_diaries_participant_date_uidx').on(table.participantId, table.sleepDate),
  index('sleep_diaries_sleep_date_idx').on(table.sleepDate),
  index('sleep_diaries_created_at_idx').on(table.createdAt),
  check('sleep_diaries_awakenings_nonnegative', sql`${table.nightAwakenings} >= 0`),
  check('sleep_diaries_awake_minutes_range', sql`${table.totalAwakeMinutes} between 0 and 1440`),
  check('sleep_diaries_nap_minutes_range', sql`${table.napMinutes} between 0 and 1440`)
])

// Email/password belong to admins only. No public registration.
export const adminUsers = pgTable('admin_users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: varchar('email', { length: 254 }).notNull(),
  passwordHash: text('password_hash').notNull(),
  isActive: boolean('is_active').default(true).notNull(),
  ...timestamps()
}, table => [
  uniqueIndex('admin_users_email_uidx').on(table.email),
  check('admin_users_email_normalized', sql`${table.email} = lower(btrim(${table.email})) and length(${table.email}) > 0`),
  check('admin_users_password_hash_not_blank', sql`length(btrim(${table.passwordHash})) > 0`)
])

export const adminSessions = pgTable('admin_sessions', {
  tokenHash: varchar('token_hash', { length: 64 }).primaryKey(),
  adminId: uuid('admin_id').notNull().references(() => adminUsers.id, { onDelete: 'cascade' }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  revokedAt: timestamp('revoked_at', { withTimezone: true })
}, table => [
  index('admin_sessions_admin_idx').on(table.adminId),
  index('admin_sessions_expires_at_idx').on(table.expiresAt),
  check('admin_sessions_hash_format', sql`${table.tokenHash} ~ '^[0-9a-f]{64}$'`),
  check('admin_sessions_expiry', sql`${table.expiresAt} > ${table.createdAt}`)
])

// Shared across serverless instances. A fixed bucket per admin plus one global bucket.
export const adminLoginLimits = pgTable('admin_login_limits', {
  key: varchar('key', { length: 64 }).primaryKey(),
  attempts: integer('attempts').notNull(),
  windowStartedAt: timestamp('window_started_at', { withTimezone: true }).notNull()
})

export const participantRequestLimits = pgTable('participant_request_limits', {
  key: varchar('key', { length: 64 }).primaryKey(),
  attempts: integer('attempts').notNull(),
  windowStartedAt: timestamp('window_started_at', { withTimezone: true }).notNull()
})

// Learning self-report only, NOT clinical adherence or completion of intervention.
// The six stable session IDs and content remain bundled, not copied into PostgreSQL.
export const participantProgress = pgTable('participant_progress', {
  participantId: uuid('participant_id').notNull().references(() => participants.id, { onDelete: 'restrict' }),
  sessionNumber: smallint('session_number').notNull(),
  firstOpenedAt: timestamp('first_opened_at', { withTimezone: true }).defaultNow().notNull(),
  lastOpenedAt: timestamp('last_opened_at', { withTimezone: true }).defaultNow().notNull(),
  completedAt: timestamp('completed_at', { withTimezone: true })
}, table => [
  primaryKey({ columns: [table.participantId, table.sessionNumber] }),
  index('participant_progress_session_completion_idx').on(table.sessionNumber, table.completedAt),
  index('participant_progress_last_opened_idx').on(table.lastOpenedAt),
  check('participant_progress_session_range', sql`${table.sessionNumber} between 1 and 6`),
  check('participant_progress_open_order', sql`${table.lastOpenedAt} >= ${table.firstOpenedAt}`),
  check('participant_progress_completion_order', sql`${table.completedAt} >= ${table.firstOpenedAt}`)
])

// Short-lived diary-only handoff from mobile to the browser helper.
// The raw value is never stored; the URL has no participant ID or profile data.
export const participantDiaryLinks = pgTable('participant_diary_links', {
  tokenHash: varchar('token_hash', { length: 64 }).primaryKey(),
  participantId: uuid('participant_id').notNull().references(() => participants.id, { onDelete: 'cascade' }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  lastUsedAt: timestamp('last_used_at', { withTimezone: true })
}, table => [
  index('participant_diary_links_participant_idx').on(table.participantId),
  index('participant_diary_links_expires_at_idx').on(table.expiresAt),
  check('participant_diary_links_hash_format', sql`${table.tokenHash} ~ '^[0-9a-f]{64}$'`),
  check('participant_diary_links_expiry', sql`${table.expiresAt} > ${table.createdAt}`)
])

export const participantsRelations = relations(participants, ({ many }) => ({
  diaries: many(sleepDiaries),
  sessions: many(participantSessions),
  progress: many(participantProgress),
  diaryLinks: many(participantDiaryLinks)
}))
export const sleepDiariesRelations = relations(sleepDiaries, ({ one }) => ({
  participant: one(participants, { fields: [sleepDiaries.participantId], references: [participants.id] })
}))
export const participantSessionsRelations = relations(participantSessions, ({ one }) => ({
  participant: one(participants, { fields: [participantSessions.participantId], references: [participants.id] })
}))
export const adminUsersRelations = relations(adminUsers, ({ many }) => ({ sessions: many(adminSessions) }))
export const participantProgressRelations = relations(participantProgress, ({ one }) => ({
  participant: one(participants, { fields: [participantProgress.participantId], references: [participants.id] })
}))
export const participantDiaryLinksRelations = relations(participantDiaryLinks, ({ one }) => ({
  participant: one(participants, { fields: [participantDiaryLinks.participantId], references: [participants.id] })
}))
export const adminSessionsRelations = relations(adminSessions, ({ one }) => ({
  admin: one(adminUsers, { fields: [adminSessions.adminId], references: [adminUsers.id] })
}))

export type Participant = typeof participants.$inferSelect
export type NewParticipant = typeof participants.$inferInsert
export type SleepDiary = typeof sleepDiaries.$inferSelect
export type NewSleepDiary = typeof sleepDiaries.$inferInsert
