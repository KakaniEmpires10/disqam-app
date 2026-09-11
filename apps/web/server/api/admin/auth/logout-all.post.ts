import { revokeAllAdminSessions } from '../../../services/admin-auth'

export default adminEndpoint(async (event) => {
  const admin = await requireAdmin(event)
  await revokeAllAdminSessions(admin.id)
  if (!getHeader(event, 'authorization')) await clearUserSession(event)
  return { loggedOut: true }
})
