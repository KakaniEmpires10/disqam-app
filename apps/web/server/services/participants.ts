import { and, eq, gt, isNull, notExists, sql } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participants, participantSessions, participantRequestLimits } from '../db/schema'
import { AuthError, newToken, tokenHash, validToken } from './auth-policy'
import { participantAccessCode, participantCode, PARTICIPANT_SESSION_SECONDS, registrationAccessToken, type registrationInput } from './participant-policy'

async function consumeParticipantLimit(key: string, maximum: number) {
  const table = participantRequestLimits
  const expired = sql`${table.windowStartedAt} <= now() - interval '15 minutes'`
  const [row] = await useDatabase().insert(table).values({ key, attempts: 1, windowStartedAt: new Date() })
    .onConflictDoUpdate({ target: table.key, set: {
      attempts: sql`case when ${expired} then 1 else least(${table.attempts} + 1, ${maximum + 1}) end`,
      windowStartedAt: sql`case when ${expired} then now() else ${table.windowStartedAt} end`
    } }).returning({ attempts: table.attempts })
  if (!row || row.attempts > maximum) throw new AuthError(429, 'Terlalu banyak permintaan. Coba lagi dalam 15 menit.')
}

export async function resolveParticipant(token: unknown) {
  if (!validToken(token)) throw new AuthError(401, 'Akses peserta belum tersedia. Silakan buka kembali akses Anda.')
  const [row] = await useDatabase().select({ id: participants.id, code: participants.code, initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender, expiresAt: participantSessions.expiresAt })
    .from(participantSessions).innerJoin(participants, eq(participants.id, participantSessions.participantId))
    .where(and(eq(participantSessions.tokenHash, tokenHash(token)), isNull(participantSessions.revokedAt), gt(participantSessions.expiresAt, sql`now()`))).limit(1)
  if (!row) throw new AuthError(401, 'Akses peserta berakhir. Hubungi admin untuk bantuan; jangan mendaftar ulang.')
  return row
}

export function publicParticipant(row: Awaited<ReturnType<typeof resolveParticipant>>) {
  return { code: row.code, initials: row.initials, ageAtEnrollment: row.ageAtEnrollment, gender: row.gender }
}

export async function registerParticipant(input: ReturnType<typeof registrationInput>) {
  const token = registrationAccessToken(input.registrationKey)
  const keyHash = tokenHash(input.registrationKey)
  const db = useDatabase()
  await consumeParticipantLimit('registration', 100)
  const profile = { initials: input.initials, ageAtEnrollment: input.ageAtEnrollment, gender: input.gender }
  // Atomic transaction: identity + initial session. Retrying never renews a revoked/expired session.
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      await db.batch([
        db.insert(participants).values({ ...profile, code: participantCode(), registrationKeyHash: keyHash })
          .onConflictDoNothing({ target: participants.registrationKeyHash }),
        db.insert(participantSessions).select(db.select({
          tokenHash: sql<string>`${tokenHash(token)}`.as('token_hash'),
          participantId: participants.id,
          createdAt: sql<Date>`now()`.as('created_at'),
          expiresAt: sql<Date>`now() + ${PARTICIPANT_SESSION_SECONDS} * interval '1 second'`.as('expires_at'),
          revokedAt: sql<Date | null>`null`.as('revoked_at')
        }).from(participants).where(and(eq(participants.registrationKeyHash, keyHash),
          notExists(db.select({ id: participantSessions.participantId }).from(participantSessions).where(eq(participantSessions.participantId, participants.id))))))
          .onConflictDoNothing({ target: participantSessions.tokenHash })
      ])
      break
    } catch (error) {
      // Drizzle wraps driver errors; retry only a random public-code collision.
      const cause = (error as { cause?: { code?: string, constraint?: string } }).cause ?? error as { code?: string, constraint?: string }
      if (cause?.code !== '23505' || cause.constraint !== 'participants_code_uidx' || attempt === 2) throw error
    }
  }
  const row = await resolveParticipant(token)
  if (row.initials !== profile.initials || row.ageAtEnrollment !== profile.ageAtEnrollment || row.gender !== profile.gender) {
    throw new AuthError(409, 'Pendaftaran ini sudah tersimpan dengan data berbeda. Gunakan data pendaftaran semula.')
  }
  const accessCode = participantAccessCode(row.code, input.registrationKey)
  await db.update(participants).set({ accessCodeHash: tokenHash(accessCode) })
    .where(and(eq(participants.id, row.id), isNull(participants.accessCodeHash)))
  return { participant: publicParticipant(row), accessCode, accessToken: token, expiresAt: row.expiresAt }
}

export async function loginParticipant(accessCode: string) {
  await consumeParticipantLimit('access-login', 100)
  const [participant] = await useDatabase().select({ id: participants.id, code: participants.code, initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender })
    .from(participants).where(eq(participants.accessCodeHash, tokenHash(accessCode))).limit(1)
  if (!participant) throw new AuthError(401, 'Kode kepesertaan tidak ditemukan atau tidak valid.')
  const token = newToken()
  const expiresAt = new Date(Date.now() + PARTICIPANT_SESSION_SECONDS * 1000)
  await useDatabase().insert(participantSessions).values({ participantId: participant.id, tokenHash: tokenHash(token), expiresAt })
  return { participant: publicParticipant({ ...participant, expiresAt }), accessToken: token, expiresAt }
}

export async function revokeParticipantSession(token: unknown) {
  if (!validToken(token)) return
  await useDatabase().update(participantSessions).set({ revokedAt: sql`now()` })
    .where(and(eq(participantSessions.tokenHash, tokenHash(token)), isNull(participantSessions.revokedAt)))
}
