export default defineNuxtRouteMiddleware(async (to) => {
  if (to.path === '/admin/login') return

  const auth = useAdminAuth()
  if (auth.status.value === 'unknown' || auth.status.value === 'error') await auth.load()
  if (!auth.user.value) {
    return navigateTo({ path: '/', query: { redirect: to.fullPath } })
  }
})
