import { resolveDiaryLink } from '../../services/diary-access'
import { newToken, tokenHash } from '../../services/auth-policy'
import { participantSessions } from '../../db/schema'
import { useDatabase } from '../../db'

export default defineEventHandler(async (event) => {
  try {
    const token = getQuery(event).token
    const link = await resolveDiaryLink(token)
    const participantTokenValue = newToken()
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000)
    const db = useDatabase()
    await db.insert(participantSessions).values({ participantId: link.participantId, tokenHash: tokenHash(participantTokenValue), expiresAt })
    setParticipantCookie(event, participantTokenValue, expiresAt)
    return sendRedirect(event, '/diary', 302)
  } catch {
    return sendRedirect(event, '/diary?accessError=1', 302)
  }
})
