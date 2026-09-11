import { and, eq, isNull } from 'drizzle-orm'
import { useDatabase } from '../db'
import { adminSessions, adminUsers } from '../db/schema'
import { AuthError } from './auth-policy'

export async function resetAdminPassword(email: string, passwordHash: string) {
  const [admin] = await useDatabase().update(adminUsers)
    .set({ passwordHash, updatedAt: new Date() })
    .where(eq(adminUsers.email, email))
    .returning({ id: adminUsers.id, email: adminUsers.email })

  if (!admin) throw new AuthError(404, 'Akun admin tidak ditemukan.')

  const revokedSessions = await useDatabase().update(adminSessions)
    .set({ revokedAt: new Date() })
    .where(and(eq(adminSessions.adminId, admin.id), isNull(adminSessions.revokedAt)))
    .returning({ tokenHash: adminSessions.tokenHash })

  return { email: admin.email, revokedSessions: revokedSessions.length }
}
