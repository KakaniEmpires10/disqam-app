import { and, eq, gt } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participantDiaryLinks, participants } from '../db/schema'
import { AuthError, newToken, tokenHash, validToken } from './auth-policy'

const LINK_SECONDS = 24 * 60 * 60

export async function createDiaryLink(participantId: string) {
  const token = newToken()
  const appUrl = process.env.APP_URL
  if (!appUrl) throw new AuthError(503, 'Tautan pengisian belum tersedia.')
  const expiresAt = new Date(Date.now() + LINK_SECONDS * 1000)
  await useDatabase().insert(participantDiaryLinks).values({ tokenHash: tokenHash(token), participantId, expiresAt })
  return { url: `${appUrl.replace(/\/$/, '')}/diary?access=${encodeURIComponent(token)}`, expiresAt }
}

export async function resolveDiaryLink(token: unknown) {
  if (!validToken(token)) throw new AuthError(401, 'Tautan pengisian tidak valid atau sudah berakhir.')
  const [row] = await useDatabase().select({ tokenHash: participantDiaryLinks.tokenHash, participantId: participantDiaryLinks.participantId, expiresAt: participantDiaryLinks.expiresAt }).from(participantDiaryLinks).innerJoin(participants, eq(participants.id, participantDiaryLinks.participantId)).where(and(eq(participantDiaryLinks.tokenHash, tokenHash(token)), gt(participantDiaryLinks.expiresAt, new Date()))).limit(1)
  if (!row) throw new AuthError(401, 'Tautan pengisian tidak valid atau sudah berakhir.')
  await useDatabase().update(participantDiaryLinks).set({ lastUsedAt: new Date() }).where(eq(participantDiaryLinks.tokenHash, row.tokenHash))
  return row
}
