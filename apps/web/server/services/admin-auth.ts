import { and, eq, gt, isNull, sql } from 'drizzle-orm'
import { useDatabase } from '../db'
import { adminLoginLimits, adminSessions, adminUsers } from '../db/schema'
import { AuthError, newToken, SESSION_SECONDS, tokenHash, validToken } from './auth-policy'

// Atomic upsert, not an in-memory limiter: works across Netlify instances.
async function consumeLimit(key: string, maximum: number) {
  const table = adminLoginLimits
  const expired = sql`${table.windowStartedAt} <= now() - interval '15 minutes'`
  const [result] = await useDatabase().insert(table).values({ key, attempts: 1, windowStartedAt: new Date() })
    .onConflictDoUpdate({ target: table.key, set: {
      attempts: sql`case when ${expired} then 1 else ${table.attempts} + 1 end`,
      windowStartedAt: sql`case when ${expired} then now() else ${table.windowStartedAt} end`
    } }).returning({ attempts: table.attempts })
  if (!result || result.attempts > maximum) throw new AuthError(429, 'Terlalu banyak percobaan login. Coba lagi dalam 15 menit.')
}

let dummyHash: Promise<string> | undefined
export async function loginAdmin(email: string, password: string) {
  await consumeLimit('global', 100)
  const [admin] = await useDatabase().select().from(adminUsers).where(eq(adminUsers.email, email)).limit(1)
  // Nonexistent emails cannot create unbounded limiter rows.
  if (admin) await consumeLimit(tokenHash(admin.id), 5)
  dummyHash ??= hashPassword(newToken())
  const correct = await verifyPassword(admin?.passwordHash ?? await dummyHash, password)
  if (!admin || !admin.isActive || !correct) throw new AuthError(401, 'Email atau password tidak sesuai.')
  const token = newToken()
  const expiresAt = new Date(Date.now() + SESSION_SECONDS * 1000)
  await useDatabase().insert(adminSessions).values({ adminId: admin.id, tokenHash: tokenHash(token), expiresAt })
  return { token, expiresAt, user: { email: admin.email } }
}

export async function resolveAdmin(token: unknown) {
  if (!validToken(token)) throw new AuthError(401, 'Silakan login sebagai admin.')
  const [record] = await useDatabase().select({ id: adminUsers.id, email: adminUsers.email, expiresAt: adminSessions.expiresAt })
    .from(adminSessions).innerJoin(adminUsers, eq(adminUsers.id, adminSessions.adminId))
    .where(and(eq(adminSessions.tokenHash, tokenHash(token)), isNull(adminSessions.revokedAt),
      gt(adminSessions.expiresAt, new Date()), eq(adminUsers.isActive, true))).limit(1)
  if (!record) throw new AuthError(401, 'Sesi berakhir. Silakan login kembali.')
  return record
}

export async function revokeToken(token: unknown) {
  if (!validToken(token)) return
  await useDatabase().update(adminSessions).set({ revokedAt: new Date() })
    .where(and(eq(adminSessions.tokenHash, tokenHash(token)), isNull(adminSessions.revokedAt)))
}

export async function revokeAllAdminSessions(adminId: string) {
  await useDatabase().update(adminSessions).set({ revokedAt: new Date() })
    .where(and(eq(adminSessions.adminId, adminId), isNull(adminSessions.revokedAt)))
}
