import { AuthError } from '../../services/auth-policy'
import { accessLoginInput } from '../../services/participant-policy'
import { loginParticipant, resolveParticipant } from '../../services/participants'

export default adminEndpoint(async (event) => {
  const browser = getHeader(event, 'origin') !== undefined
  assertAuthRequest(event, !browser)
  const existing = participantToken(event)
  if (existing) {
    try {
      await resolveParticipant(existing)
      throw new AuthError(409, 'Akses peserta sudah ada di perangkat ini.')
    } catch (error) {
      if (!(error instanceof AuthError) || error.status !== 401) throw error
      clearParticipantCookie(event)
    }
  }
  const result = await loginParticipant(accessLoginInput(await readParticipantBody(event)).accessCode)
  if (browser) {
    setParticipantCookie(event, result.accessToken, result.expiresAt)
    return { participant: result.participant, expiresAt: result.expiresAt }
  }
  return { ...result, tokenType: 'Bearer' }
})
