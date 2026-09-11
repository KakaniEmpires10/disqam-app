import { resolveAdmin, revokeToken } from '../services/admin-auth'
import { AuthError } from '../services/auth-policy'

export default defineNitroPlugin(() => {
  sessionHooks.hook('fetch', async (session, event) => {
    setHeader(event, 'Cache-Control', 'no-store')
    if (!session.secure?.adminToken) {
      delete session.user
      return
    }
    try {
      const admin = await resolveAdmin(session.secure.adminToken)
      session.user = { email: admin.email }
    } catch (error) {
      delete session.user
      throw createError({ statusCode: error instanceof AuthError ? error.status : 503, message: 'Sesi tidak tersedia. Silakan coba login kembali.' })
    }
  })
  sessionHooks.hook('clear', async (session, event) => {
    assertBrowserOrigin(event)
    await revokeToken(session.secure?.adminToken)
  })
})
