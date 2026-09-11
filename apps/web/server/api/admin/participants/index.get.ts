import { listParticipants, participantGenderFilter, participantPage, participantProgressFilter } from '../../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  const query = getQuery(event)
  return listParticipants(participantPage(query.page), {
    search: typeof query.search === 'string' ? query.search : undefined,
    gender: participantGenderFilter(query.gender),
    progress: participantProgressFilter(query.progress)
  })
})
