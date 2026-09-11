import { and, desc, eq } from 'drizzle-orm'
import { useDatabase } from '../db'
import { sleepDiaries } from '../db/schema'
import { AuthError } from './auth-policy'
import { objectBody } from './participant-policy'

const timePattern = /^([01]\d|2[0-3]):[0-5]\d$/
const datePattern = /^\d{4}-\d{2}-\d{2}$/

function optionalMinutes(value: unknown, label: string, maximum = 1440) {
  if (value === null || value === undefined) return null
  if (typeof value !== 'number' || !Number.isInteger(value) || value < 0 || value > maximum) throw new AuthError(400, `${label} tidak valid.`)
  return value
}

function time(value: unknown, label: string, required = true) {
  if ((value === null || value === undefined || value === '') && !required) return null
  if (typeof value !== 'string' || !timePattern.test(value)) throw new AuthError(400, `${label} tidak valid.`)
  return value
}

export function sleepDiaryInput(value: unknown) {
  const body = objectBody(value, ['sleepDate', 'bedTime', 'sleepStartTime', 'nightAwakenings', 'totalAwakeMinutes', 'finalWakeTime', 'outOfBedTime', 'napMinutes'])
  if (typeof body.sleepDate !== 'string' || !datePattern.test(body.sleepDate)) throw new AuthError(400, 'Tanggal catatan tidak valid.')
  const date = new Date(`${body.sleepDate}T00:00:00Z`)
  if (Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== body.sleepDate) throw new AuthError(400, 'Tanggal catatan tidak valid.')
  const awakenings = optionalMinutes(body.nightAwakenings, 'Jumlah terbangun', 100)
  return {
    sleepDate: body.sleepDate,
    bedTime: time(body.bedTime, 'Jam masuk tempat tidur')!,
    sleepStartTime: time(body.sleepStartTime, 'Jam mulai tidur', false),
    nightAwakenings: awakenings,
    totalAwakeMinutes: optionalMinutes(body.totalAwakeMinutes, 'Total lama terjaga'),
    finalWakeTime: time(body.finalWakeTime, 'Jam bangun terakhir')!,
    outOfBedTime: time(body.outOfBedTime, 'Jam keluar dari tempat tidur')!,
    napMinutes: optionalMinutes(body.napMinutes, 'Durasi tidur siang')
  }
}

export async function listSleepDiaries(participantId: string) {
  return useDatabase().select({ id: sleepDiaries.id, sleepDate: sleepDiaries.sleepDate, bedTime: sleepDiaries.bedTime, sleepStartTime: sleepDiaries.sleepStartTime, nightAwakenings: sleepDiaries.nightAwakenings, totalAwakeMinutes: sleepDiaries.totalAwakeMinutes, finalWakeTime: sleepDiaries.finalWakeTime, outOfBedTime: sleepDiaries.outOfBedTime, napMinutes: sleepDiaries.napMinutes, updatedAt: sleepDiaries.updatedAt }).from(sleepDiaries).where(eq(sleepDiaries.participantId, participantId)).orderBy(desc(sleepDiaries.sleepDate), desc(sleepDiaries.updatedAt)).limit(60)
}

export async function saveSleepDiary(participantId: string, input: ReturnType<typeof sleepDiaryInput>) {
  const [row] = await useDatabase().insert(sleepDiaries).values({ participantId, ...input }).onConflictDoUpdate({ target: [sleepDiaries.participantId, sleepDiaries.sleepDate], set: { ...input, updatedAt: new Date() } }).returning({ id: sleepDiaries.id, sleepDate: sleepDiaries.sleepDate, bedTime: sleepDiaries.bedTime, sleepStartTime: sleepDiaries.sleepStartTime, nightAwakenings: sleepDiaries.nightAwakenings, totalAwakeMinutes: sleepDiaries.totalAwakeMinutes, finalWakeTime: sleepDiaries.finalWakeTime, outOfBedTime: sleepDiaries.outOfBedTime, napMinutes: sleepDiaries.napMinutes, updatedAt: sleepDiaries.updatedAt })
  return row
}

export async function deleteSleepDiary(participantId: string, sleepDate: string) {
  if (!datePattern.test(sleepDate)) throw new AuthError(400, 'Tanggal catatan tidak valid.')
  await useDatabase().delete(sleepDiaries).where(and(eq(sleepDiaries.participantId, participantId), eq(sleepDiaries.sleepDate, sleepDate)))
}
