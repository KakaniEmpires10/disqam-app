import { publicParticipant } from '../../services/participants'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return { participant: publicParticipant(participant), expiresAt: participant.expiresAt }
})
