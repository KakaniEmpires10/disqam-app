import { revokeParticipantSession } from '../../services/participants'

export default adminEndpoint(async (event) => {
  participantWriteGuard(event)
  await revokeParticipantSession(participantToken(event))
  if (!getHeader(event, 'authorization')) clearParticipantCookie(event)
  return { loggedOut: true }
})
