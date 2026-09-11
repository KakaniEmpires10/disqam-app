import { revokeToken } from '../../../services/admin-auth'

export default adminEndpoint(async (event) => {
  assertAuthRequest(event, !!getHeader(event, 'authorization'))
  await revokeToken(await getAdminToken(event))
  if (!getHeader(event, 'authorization')) await clearUserSession(event)
  return { loggedOut: true }
})
