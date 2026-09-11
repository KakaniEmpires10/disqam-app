import { desc, eq } from 'drizzle-orm'
import { useDatabase } from '../../db'
import { participants, sleepDiaries } from '../../db/schema'

function csvCell(value: unknown) {
  const text = value === null || value === undefined ? '' : String(value)
  return `"${text.replaceAll('"', '""')}"`
}

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
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
  }).from(sleepDiaries).innerJoin(participants, eq(participants.id, sleepDiaries.participantId)).orderBy(desc(sleepDiaries.sleepDate))

  const header = ['Kode peserta', 'Inisial', 'Usia', 'Jenis kelamin', 'Tanggal tidur', 'Masuk tempat tidur', 'Mulai tidur', 'Terbangun malam (kali)', 'Total terjaga (menit)', 'Bangun terakhir', 'Keluar tempat tidur', 'Tidur siang (menit)', 'Diperbarui']
  const body = rows.map(row => [
    row.code, row.initials, row.age, row.gender, row.sleepDate, row.bedTime, row.sleepStartTime,
    row.nightAwakenings, row.totalAwakeMinutes, row.finalWakeTime, row.outOfBedTime, row.napMinutes,
    row.updatedAt.toISOString()
  ].map(csvCell).join(','))

  setHeader(event, 'Content-Type', 'text/csv; charset=utf-8')
  setHeader(event, 'Content-Disposition', 'attachment; filename="disqam-sleep-diary.csv"')
  return '\uFEFF' + [header.map(csvCell).join(','), ...body].join('\r\n')
})
