import { AuthError } from '../../services/auth-policy'
import { buildAdminExport, parseExportRequest } from '../../services/admin-export'

export default defineEventHandler(async (event) => {
  try {
    await requireAdmin(event)
    const result = await buildAdminExport(parseExportRequest(getQuery(event)))
    setHeader(event, 'Content-Type', result.contentType)
    setHeader(event, 'Content-Disposition', `attachment; filename="${result.filename}"`)
    setHeader(event, 'Cache-Control', 'private, no-store')
    return result.body
  } catch (error) {
    if (error instanceof AuthError) {
      throw createError({ statusCode: error.status, statusMessage: error.message })
    }
    throw error
  }
})
