import { listDiaryParticipants, participantPage } from '../../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  const query = getQuery(event)
  return listDiaryParticipants(participantPage(query.page), typeof query.search === 'string' ? query.search : undefined)
})
