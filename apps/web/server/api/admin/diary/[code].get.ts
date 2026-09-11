import { diaryParticipantDetail } from '../../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  return diaryParticipantDetail({
    code: getRouterParam(event, 'code'),
    from: getQuery(event).from,
    to: getQuery(event).to
  })
})
