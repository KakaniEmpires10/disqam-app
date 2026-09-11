import { loginAdmin, revokeToken } from '../../../services/admin-auth'

export default adminEndpoint(async (event) => {
  assertAuthRequest(event)
  const { email, password } = await readCredentials(event)
  const result = await loginAdmin(email, password)
  try {
    await revokeToken((await getUserSession(event)).secure?.adminToken)
    await replaceUserSession(event, { user: result.user, secure: { adminToken: result.token } })
  } catch (error) {
    await revokeToken(result.token)
    throw error
  }
  return { user: result.user, expiresAt: result.expiresAt }
})
