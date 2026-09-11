import { and, count, desc, eq, gte, ilike, lte, or, sql, type SQL } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participants, participantProgress, sleepDiaries } from '../db/schema'
import { AuthError } from './auth-policy'
import { readProgress } from './program-progress'
import { objectBody, PROGRAM_SESSIONS } from './participant-policy'

export function participantPage(value: unknown) {
  if (value === undefined) return 1
  if (typeof value !== 'string' || !/^[1-9]\d{0,4}$/.test(value)) throw new AuthError(400, 'Halaman tidak valid.')
  return Number(value)
}

function progressStats() {
  return useDatabase().select({ participantId: participantProgress.participantId,
    opened: count().as('opened'),
    completed: sql<number>`count(*) filter (where ${participantProgress.completedAt} is not null)`.mapWith(Number).as('completed'),
    lastActivity: sql<Date>`greatest(max(${participantProgress.lastOpenedAt}), max(${participantProgress.completedAt}))`.mapWith(value => new Date(value)).as('last_activity')
  }).from(participantProgress).groupBy(participantProgress.participantId).as('progress_stats')
}

export function participantGenderFilter(value: unknown) {
  if (value === undefined || value === '' || value === 'all') return undefined
  if (value !== 'male' && value !== 'female' && value !== 'unspecified') throw new AuthError(400, 'Filter jenis kelamin tidak valid.')
  return value
}

export function participantProgressFilter(value: unknown) {
  if (value === undefined || value === '' || value === 'all') return undefined
  if (value !== 'not-started' && value !== 'in-progress' && value !== 'completed') throw new AuthError(400, 'Filter progress tidak valid.')
  return value
}

export async function listParticipants(page: number, filters: {
  search?: string
  gender?: ReturnType<typeof participantGenderFilter>
  progress?: ReturnType<typeof participantProgressFilter>
} = {}) {
  const db = useDatabase()
  const stats = progressStats()
  const pageSize = 20
  const conditions: SQL[] = []
  const normalizedSearch = filters.search?.trim().slice(0, 80)

  if (normalizedSearch) conditions.push(or(
    ilike(participants.code, `%${normalizedSearch}%`),
    ilike(participants.initials, `%${normalizedSearch}%`)
  )!)
  if (filters.gender) conditions.push(eq(participants.gender, filters.gender))
  if (filters.progress === 'not-started') conditions.push(sql`coalesce(${stats.opened}, 0) = 0`)
  if (filters.progress === 'in-progress') conditions.push(sql`coalesce(${stats.opened}, 0) > 0 and coalesce(${stats.completed}, 0) < 6`)
  if (filters.progress === 'completed') conditions.push(sql`coalesce(${stats.completed}, 0) = 6`)

  const where = conditions.length ? and(...conditions) : undefined
  const [items, totals] = await Promise.all([
    db.select({ id: participants.id, code: participants.code, initials: participants.initials,
      ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender, createdAt: participants.createdAt,
      openedSessions: sql<number>`coalesce(${stats.opened}, 0)`.mapWith(Number),
      completedSessions: sql<number>`coalesce(${stats.completed}, 0)`.mapWith(Number),
      lastLearningActivityAt: stats.lastActivity
    }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id))
      .where(where).orderBy(desc(participants.createdAt), desc(participants.id)).limit(pageSize).offset((page - 1) * pageSize),
    db.select({ total: count() }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id)).where(where)
  ])
  return { items, page, pageSize, total: Number(totals[0]?.total ?? 0) }
}

export async function participantLearningSummary() {
  const stats = progressStats()
  const [summary] = await useDatabase().select({ totalParticipants: count(),
    startedLearning: sql<number>`count(*) filter (where ${stats.opened} > 0)`.mapWith(Number),
    completedLearning: sql<number>`count(*) filter (where ${stats.completed} = 6)`.mapWith(Number)
  }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id))
  return summary
}

export async function dashboardSummary() {
  const db = useDatabase()
  const stats = progressStats()
  const activityCutoff = new Date(Date.now() - 14 * 24 * 60 * 60 * 1000)
  const diaryCutoff = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)

  const [summaryRows, sessionRows, diaryRows, activeProgressRows, activeDiaryRows, progressActivities, diaryActivities] = await Promise.all([
    db.select({
      totalParticipants: sql<number>`count(*)`.mapWith(Number),
      startedLearning: sql<number>`count(*) filter (where coalesce(${stats.opened}, 0) > 0)`.mapWith(Number),
      completedLearning: sql<number>`count(*) filter (where ${stats.completed} = 6)`.mapWith(Number)
    }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id)),
    db.select({
      sessionNumber: participantProgress.sessionNumber,
      opened: sql<number>`count(*)`.mapWith(Number),
      completed: sql<number>`count(*) filter (where ${participantProgress.completedAt} is not null)`.mapWith(Number)
    }).from(participantProgress).groupBy(participantProgress.sessionNumber).orderBy(participantProgress.sessionNumber),
    db.select({
      totalEntries: sql<number>`count(*)`.mapWith(Number),
      lastSevenDays: sql<number>`count(*) filter (where ${sleepDiaries.updatedAt} >= ${diaryCutoff})`.mapWith(Number),
      activeParticipants: sql<number>`count(distinct ${sleepDiaries.participantId}) filter (where ${sleepDiaries.updatedAt} >= ${activityCutoff})`.mapWith(Number)
    }).from(sleepDiaries),
    db.select({ participantId: participantProgress.participantId }).from(participantProgress).where(or(
      gte(participantProgress.lastOpenedAt, activityCutoff),
      gte(participantProgress.completedAt, activityCutoff)
    )),
    db.select({ participantId: sleepDiaries.participantId }).from(sleepDiaries).where(gte(sleepDiaries.updatedAt, activityCutoff)),
    db.select({
      code: participants.code,
      initials: participants.initials,
      sessionNumber: participantProgress.sessionNumber,
      lastOpenedAt: participantProgress.lastOpenedAt,
      completedAt: participantProgress.completedAt
    }).from(participantProgress).innerJoin(participants, eq(participants.id, participantProgress.participantId)).orderBy(desc(participantProgress.lastOpenedAt)).limit(10),
    db.select({
      code: participants.code,
      initials: participants.initials,
      updatedAt: sleepDiaries.updatedAt
    }).from(sleepDiaries).innerJoin(participants, eq(participants.id, sleepDiaries.participantId)).orderBy(desc(sleepDiaries.updatedAt)).limit(10)
  ])

  const activeParticipantIds = new Set([
    ...activeProgressRows.map(row => row.participantId),
    ...activeDiaryRows.map(row => row.participantId)
  ])
  const sessionNumbers = ['I', 'II', 'III', 'IV', 'V', 'VI']
  const recentActivity = [
    ...progressActivities.map((activity) => {
      const occurredAt = activity.completedAt && activity.completedAt > activity.lastOpenedAt
        ? activity.completedAt
        : activity.lastOpenedAt
      return {
        code: activity.code,
        initials: activity.initials,
        event: activity.completedAt ? `menandai Sesi ${activity.sessionNumber} selesai` : `membuka Sesi ${activity.sessionNumber}`,
        occurredAt
      }
    }),
    ...diaryActivities.map(activity => ({
      code: activity.code,
      initials: activity.initials,
      event: 'mengisi buku harian tidur',
      occurredAt: activity.updatedAt
    }))
  ]
    .sort((left, right) => right.occurredAt.getTime() - left.occurredAt.getTime())
    .slice(0, 6)
    .map(activity => ({ ...activity, time: activity.occurredAt.toISOString() }))

  const sessionProgress = PROGRAM_SESSIONS.map((session) => {
    const row = sessionRows.find(item => item.sessionNumber === session.number)
    return {
      session: sessionNumbers[session.number - 1],
      title: session.title,
      completed: row?.completed ?? 0,
      opened: row?.opened ?? 0,
      total: summaryRows[0]?.totalParticipants ?? 0
    }
  })

  return {
    summary: {
      totalParticipants: summaryRows[0]?.totalParticipants ?? 0,
      activeParticipants: activeParticipantIds.size,
      startedLearning: summaryRows[0]?.startedLearning ?? 0,
      completedLearning: summaryRows[0]?.completedLearning ?? 0
    },
    sessionProgress,
    diarySummary: {
      totalEntries: diaryRows[0]?.totalEntries ?? 0,
      lastSevenDays: diaryRows[0]?.lastSevenDays ?? 0,
      activeParticipants: diaryRows[0]?.activeParticipants ?? 0,
      note: 'Ringkasan aktivitas pencatatan, bukan penilaian klinis.'
    },
    recentActivity
  }
}

export async function participantDetail(value: unknown) {
  const body = objectBody(value, ['participantId'])
  if (typeof body.participantId !== 'string' || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(body.participantId)) throw new AuthError(400, 'Peserta tidak valid.')
  const [participant] = await useDatabase().select({ id: participants.id, code: participants.code, initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender, createdAt: participants.createdAt
  }).from(participants).where(eq(participants.id, body.participantId)).limit(1)
  if (!participant) throw new AuthError(404, 'Peserta tidak ditemukan.')
  return { participant, progress: await readProgress(participant.id) }
}

function validDate(value: unknown, label: string) {
  if (value === undefined || value === '') return undefined
  if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) throw new AuthError(400, `${label} tidak valid.`)
  const parsed = new Date(`${value}T00:00:00Z`)
  if (Number.isNaN(parsed.getTime()) || parsed.toISOString().slice(0, 10) !== value) throw new AuthError(400, `${label} tidak valid.`)
  return value
}

function timeMinutes(value: string) {
  const [hours = 0, minutes = 0] = value.split(':').map(Number)
  return hours * 60 + minutes
}

function overnightMinutes(end: string, start: string) {
  const result = timeMinutes(end) - timeMinutes(start)
  return result >= 0 ? result : result + 1440
}

function diaryMetrics(entry: {
  bedTime: string
  sleepStartTime: string | null
  finalWakeTime: string
  outOfBedTime: string
  totalAwakeMinutes: number | null
  nightAwakenings: number | null
  napMinutes: number | null
}) {
  const timeInBedMinutes = overnightMinutes(entry.outOfBedTime, entry.bedTime)
  const sleepMinutes = entry.sleepStartTime
    ? overnightMinutes(entry.finalWakeTime, entry.sleepStartTime)
    : timeInBedMinutes - (entry.totalAwakeMinutes ?? 0)
  const sleepEfficiency = timeInBedMinutes > 0 && sleepMinutes >= 0
    ? Math.round((sleepMinutes / timeInBedMinutes) * 1000) / 10
    : null
  const isComplete = [entry.sleepStartTime, entry.nightAwakenings, entry.totalAwakeMinutes, entry.napMinutes].every(value => value !== null)
  return { timeInBedMinutes, sleepMinutes, sleepEfficiency, isComplete }
}

export async function diaryAnalyticsSummary() {
  const rows = await useDatabase().select({
    participantId: participants.id,
    code: participants.code,
    initials: participants.initials,
    diaryId: sleepDiaries.id,
    sleepDate: sleepDiaries.sleepDate,
    bedTime: sleepDiaries.bedTime,
    sleepStartTime: sleepDiaries.sleepStartTime,
    nightAwakenings: sleepDiaries.nightAwakenings,
    totalAwakeMinutes: sleepDiaries.totalAwakeMinutes,
    finalWakeTime: sleepDiaries.finalWakeTime,
    outOfBedTime: sleepDiaries.outOfBedTime,
    napMinutes: sleepDiaries.napMinutes,
    updatedAt: sleepDiaries.updatedAt
  }).from(participants).leftJoin(sleepDiaries, eq(sleepDiaries.participantId, participants.id)).orderBy(participants.code, desc(sleepDiaries.sleepDate))

  const grouped = new Map<string, {
    code: string
    initials: string
    diaryCount: number
    completeEntries: number
    efficiencies: number[]
    sleepMinutes: number[]
    timeInBedMinutes: number[]
    lastDiaryAt: Date | null
  }>()

  for (const row of rows) {
    const bedTime = row.bedTime
    const finalWakeTime = row.finalWakeTime
    const outOfBedTime = row.outOfBedTime
    const updatedAt = row.updatedAt
    const current = grouped.get(row.participantId) || {
      code: row.code,
      initials: row.initials,
      diaryCount: 0,
      completeEntries: 0,
      efficiencies: [],
      sleepMinutes: [],
      timeInBedMinutes: [],
      lastDiaryAt: null
    }

    if (row.diaryId && row.sleepDate && bedTime && finalWakeTime && outOfBedTime && updatedAt) {
      const metrics = diaryMetrics({
        bedTime,
        sleepStartTime: row.sleepStartTime,
        finalWakeTime,
        outOfBedTime,
        totalAwakeMinutes: row.totalAwakeMinutes,
        nightAwakenings: row.nightAwakenings,
        napMinutes: row.napMinutes
      })
      current.diaryCount += 1
      if (metrics.isComplete) current.completeEntries += 1
      if (metrics.sleepEfficiency !== null) current.efficiencies.push(metrics.sleepEfficiency)
      if (metrics.sleepMinutes >= 0) current.sleepMinutes.push(metrics.sleepMinutes)
      current.timeInBedMinutes.push(metrics.timeInBedMinutes)
      if (!current.lastDiaryAt || updatedAt > current.lastDiaryAt) current.lastDiaryAt = updatedAt
    }

    grouped.set(row.participantId, current)
  }

  const participantsSummary = [...grouped.values()].map((participant) => {
    const average = (values: number[]) => values.length
      ? Math.round(values.reduce((sum, value) => sum + value, 0) / values.length * 10) / 10
      : null
    return {
      code: participant.code,
      initials: participant.initials,
      diaryCount: participant.diaryCount,
      completeEntries: participant.completeEntries,
      completenessRate: participant.diaryCount
        ? Math.round(participant.completeEntries / participant.diaryCount * 1000) / 10
        : null,
      averageSleepEfficiency: average(participant.efficiencies),
      averageSleepMinutes: average(participant.sleepMinutes),
      averageTimeInBedMinutes: average(participant.timeInBedMinutes),
      lastDiaryAt: participant.lastDiaryAt?.toISOString() || null
    }
  })

  const allEfficiency = participantsSummary.flatMap(participant => participant.averageSleepEfficiency === null ? [] : [participant.averageSleepEfficiency])
  const totalEntries = participantsSummary.reduce((sum, participant) => sum + participant.diaryCount, 0)
  const completeEntries = participantsSummary.reduce((sum, participant) => sum + participant.completeEntries, 0)
  const average = (values: number[]) => values.length
    ? Math.round(values.reduce((sum, value) => sum + value, 0) / values.length * 10) / 10
    : null

  return {
    summary: {
      totalEntries,
      completeEntries,
      participantsWithDiary: participantsSummary.filter(participant => participant.diaryCount > 0).length,
      averageSleepEfficiency: average(allEfficiency),
      completenessRate: totalEntries ? Math.round(completeEntries / totalEntries * 1000) / 10 : null
    },
    participants: participantsSummary,
    note: 'Metrik ini membantu membaca pola pencatatan, bukan diagnosis atau penilaian klinis.'
  }
}

export async function listDiaryParticipants(page: number, search?: string) {
  const db = useDatabase()
  const pageSize = 20
  const normalizedSearch = search?.trim()
  const where = normalizedSearch ? ilike(participants.code, `%${normalizedSearch}%`) : undefined
  const [items, totals] = await Promise.all([
    db.select({
      id: participants.id,
      code: participants.code,
      initials: participants.initials,
      ageAtEnrollment: participants.ageAtEnrollment,
      gender: participants.gender,
      diaryCount: sql<number>`count(${sleepDiaries.id})`.mapWith(Number),
      lastDiaryAt: sql<Date | null>`max(${sleepDiaries.updatedAt})`
    }).from(participants).leftJoin(sleepDiaries, eq(sleepDiaries.participantId, participants.id)).where(where)
      .groupBy(participants.id).orderBy(desc(sql`max(${sleepDiaries.updatedAt})`), desc(participants.createdAt))
      .limit(pageSize).offset((page - 1) * pageSize),
    db.select({ total: count() }).from(participants).where(where)
  ])
  return { items, page, pageSize, total: Number(totals[0]?.total ?? 0) }
}

export async function diaryParticipantDetail(value: unknown) {
  const body = objectBody(value, ['code', 'from', 'to'])
  if (typeof body.code !== 'string' || !/^DQ-[A-HJ-NP-Z2-9]{8,16}$/.test(body.code)) throw new AuthError(400, 'Kode peserta tidak valid.')
  const from = validDate(body.from, 'Tanggal mulai')
  const to = validDate(body.to, 'Tanggal akhir')
  if (from && to && from > to) throw new AuthError(400, 'Rentang tanggal tidak valid.')

  const [participant] = await useDatabase().select({
    id: participants.id,
    code: participants.code,
    initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment,
    gender: participants.gender
  }).from(participants).where(eq(participants.code, body.code)).limit(1)
  if (!participant) throw new AuthError(404, 'Peserta tidak ditemukan.')

  const conditions = [eq(sleepDiaries.participantId, participant.id)]
  if (from) conditions.push(gte(sleepDiaries.sleepDate, from))
  if (to) conditions.push(lte(sleepDiaries.sleepDate, to))
  const entries = await useDatabase().select({
    sleepDate: sleepDiaries.sleepDate,
    bedTime: sleepDiaries.bedTime,
    sleepStartTime: sleepDiaries.sleepStartTime,
    nightAwakenings: sleepDiaries.nightAwakenings,
    totalAwakeMinutes: sleepDiaries.totalAwakeMinutes,
    finalWakeTime: sleepDiaries.finalWakeTime,
    outOfBedTime: sleepDiaries.outOfBedTime,
    napMinutes: sleepDiaries.napMinutes,
    updatedAt: sleepDiaries.updatedAt
  }).from(sleepDiaries).where(and(...conditions)).orderBy(desc(sleepDiaries.sleepDate), desc(sleepDiaries.updatedAt))

  return {
    participant,
    entries: entries.map(entry => ({ ...entry, ...diaryMetrics(entry) }))
  }
}
