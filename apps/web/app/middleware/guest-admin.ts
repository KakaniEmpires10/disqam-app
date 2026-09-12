export default defineNuxtRouteMiddleware(async (to) => {
  const auth = useAdminAuth()

  if (auth.status.value === 'unknown' || auth.status.value === 'error') {
    await auth.load()
  }

  if (!auth.user.value) return

  const redirect = to.query.redirect
  const destination = typeof redirect === 'string'
    && redirect.startsWith('/admin')
    && redirect !== '/admin/login'
    ? redirect
    : '/admin'

  return navigateTo(destination, { redirectCode: 302 })
})
