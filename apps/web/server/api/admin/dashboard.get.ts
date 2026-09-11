import { dashboardSummary } from '../../services/participant-monitoring'

export default adminEndpoint(async (event) => {
  await requireAdmin(event)
  return dashboardSummary()
})
