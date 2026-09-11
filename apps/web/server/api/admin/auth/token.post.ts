import { loginAdmin } from '../../../services/admin-auth'

export default adminEndpoint(async (event) => {
  assertAuthRequest(event, true)
  const { email, password } = await readCredentials(event)
  const result = await loginAdmin(email, password)
  return { user: result.user, accessToken: result.token, tokenType: 'Bearer', expiresAt: result.expiresAt }
})
