import { registerParticipant, resolveParticipant } from '../../services/participants'
import { registrationAccessToken, registrationInput } from '../../services/participant-policy'
import { AuthError } from '../../services/auth-policy'

export default adminEndpoint(async (event) => {
  const browser = getHeader(event, 'origin') !== undefined
  assertAuthRequest(event, !browser)
  const input = registrationInput(await readParticipantBody(event))
  // Permit a retry after Set-Cookie arrived but the JSON response was lost.
  const existing = participantToken(event)
  if (existing) {
    try {
      await resolveParticipant(existing)
      if (existing !== registrationAccessToken(input.registrationKey)) throw new AuthError(409, 'Akses peserta sudah ada. Gunakan akses yang tersimpan.')
    } catch (error) {
      if (!(error instanceof AuthError) || error.status !== 401) throw error
      clearParticipantCookie(event)
    }
  }
  const result = await registerParticipant(input)
  if (browser) {
    setParticipantCookie(event, result.accessToken, result.expiresAt)
    return { participant: result.participant, accessCode: result.accessCode, expiresAt: result.expiresAt }
  }
  return { ...result, tokenType: 'Bearer' }
})
