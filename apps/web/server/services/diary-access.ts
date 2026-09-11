import { and, eq, gt, isNull } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participantDiaryLinks, participants } from '../db/schema'
import { AuthError, newToken, tokenHash, validToken } from './auth-policy'

const LINK_SECONDS = 30 * 60

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
  const db = useDatabase()
  const [link] = await db.update(participantDiaryLinks)
    .set({ lastUsedAt: new Date() })
    .where(and(
      eq(participantDiaryLinks.tokenHash, tokenHash(token)),
      isNull(participantDiaryLinks.lastUsedAt),
      gt(participantDiaryLinks.expiresAt, new Date())
    ))
    .returning({ tokenHash: participantDiaryLinks.tokenHash, participantId: participantDiaryLinks.participantId, expiresAt: participantDiaryLinks.expiresAt })
  if (!link) throw new AuthError(401, 'Tautan pengisian tidak valid, sudah dipakai, atau sudah berakhir.')

  const [participant] = await db.select({ id: participants.id }).from(participants).where(eq(participants.id, link.participantId)).limit(1)
  if (!participant) throw new AuthError(401, 'Tautan pengisian tidak dapat digunakan.')
  return link
}
