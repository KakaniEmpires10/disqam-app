import { AuthError } from '../../services/auth-policy'
import { buildParticipantDiaryExport, parseParticipantExportPeriod } from '../../services/participant-export'

export default defineEventHandler(async (event) => {
  try {
    const participant = await requireParticipant(event)
    const result = await buildParticipantDiaryExport(participant.id, parseParticipantExportPeriod(getQuery(event)))
    setHeader(event, 'Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    setHeader(event, 'Content-Disposition', `attachment; filename="${result.filename}"`)
    setHeader(event, 'Cache-Control', 'private, no-store')
    return result.body
  } catch (error) {
    if (error instanceof AuthError) throw createError({ statusCode: error.status, statusMessage: error.message })
    throw error
  }
})
