import { recordProgress } from '../../services/program-progress'
import { progressInput } from '../../services/participant-policy'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return recordProgress(participant.id, progressInput(await readParticipantBody(event)))
})
