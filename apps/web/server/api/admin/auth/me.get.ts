export default adminEndpoint(async (event) => {
  const admin = await requireAdmin(event)
  return { user: { email: admin.email }, expiresAt: admin.expiresAt }
})
