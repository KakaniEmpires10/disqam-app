import { deleteSleepDiary } from '../../services/sleep-diary'
import { AuthError } from '../../services/auth-policy'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  const body = await readParticipantBody(event)
  const sleepDate = body && typeof body === 'object' && !Array.isArray(body) && typeof (body as Record<string, unknown>).sleepDate === 'string'
    ? (body as Record<string, unknown>).sleepDate
    : undefined
  if (typeof sleepDate !== 'string') throw new AuthError(400, 'Tanggal catatan tidak valid.')
  await deleteSleepDiary(participant.id, sleepDate)
  return { deleted: true }
})
