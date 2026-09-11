import { readProgress } from '../../services/program-progress'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return readProgress(participant.id)
})
