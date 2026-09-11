import { participantDetail } from '../../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  return participantDetail(await readParticipantBody(event))
})
