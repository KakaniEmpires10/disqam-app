import { and, desc, eq, gte, lte, type SQL } from 'drizzle-orm'
import { useDatabase } from '../../db'
import { participants, sleepDiaries } from '../../db/schema'
import { AuthError } from '../../services/auth-policy'

function csvCell(value: unknown) {
  const text = value === null || value === undefined ? '' : String(value)
  return `"${text.replaceAll('"', '""')}"`
}

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const query = getQuery(event)
  const code = typeof query.code === 'string' && query.code ? query.code : undefined
  const from = typeof query.from === 'string' && query.from ? query.from : undefined
  const to = typeof query.to === 'string' && query.to ? query.to : undefined
  if (code && !/^DQ-[A-HJ-NP-Z2-9]{8,16}$/.test(code)) throw new AuthError(400, 'Kode peserta tidak valid.')
  if (from && !/^\d{4}-\d{2}-\d{2}$/.test(from)) throw new AuthError(400, 'Tanggal mulai tidak valid.')
  if (to && !/^\d{4}-\d{2}-\d{2}$/.test(to)) throw new AuthError(400, 'Tanggal akhir tidak valid.')
  if (from && to && from > to) throw new AuthError(400, 'Rentang tanggal tidak valid.')

  const conditions: SQL[] = []
  if (code) conditions.push(eq(participants.code, code))
  if (from) conditions.push(gte(sleepDiaries.sleepDate, from))
  if (to) conditions.push(lte(sleepDiaries.sleepDate, to))

  const rows = await useDatabase().select({
    code: participants.code,
    initials: participants.initials,
    age: participants.ageAtEnrollment,
    gender: participants.gender,
    sleepDate: sleepDiaries.sleepDate,
    bedTime: sleepDiaries.bedTime,
    sleepStartTime: sleepDiaries.sleepStartTime,
    nightAwakenings: sleepDiaries.nightAwakenings,
    totalAwakeMinutes: sleepDiaries.totalAwakeMinutes,
    finalWakeTime: sleepDiaries.finalWakeTime,
    outOfBedTime: sleepDiaries.outOfBedTime,
    napMinutes: sleepDiaries.napMinutes,
    updatedAt: sleepDiaries.updatedAt
  }).from(sleepDiaries).innerJoin(participants, eq(participants.id, sleepDiaries.participantId)).where(conditions.length ? and(...conditions) : undefined).orderBy(desc(sleepDiaries.sleepDate))

  const header = ['Kode peserta', 'Inisial', 'Usia', 'Jenis kelamin', 'Tanggal tidur', 'Masuk tempat tidur', 'Mulai tidur', 'Terbangun malam (kali)', 'Total terjaga (menit)', 'Bangun terakhir', 'Keluar tempat tidur', 'Tidur siang (menit)', 'Diperbarui']
  const body = rows.map(row => [
    row.code, row.initials, row.age, row.gender, row.sleepDate, row.bedTime, row.sleepStartTime,
    row.nightAwakenings, row.totalAwakeMinutes, row.finalWakeTime, row.outOfBedTime, row.napMinutes,
    row.updatedAt.toISOString()
  ].map(csvCell).join(','))

  setHeader(event, 'Content-Type', 'text/csv; charset=utf-8')
  setHeader(event, 'Content-Disposition', `attachment; filename="disqam-sleep-diary${code ? `-${code}` : ''}.csv"`)
  return '\uFEFF' + [header.map(csvCell).join(','), ...body].join('\r\n')
})
