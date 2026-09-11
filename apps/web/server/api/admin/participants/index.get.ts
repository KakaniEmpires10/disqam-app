import { listParticipants, participantPage } from '../../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  return listParticipants(participantPage(getQuery(event).page))
})
