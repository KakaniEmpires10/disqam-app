import { count, desc, eq, gte, or, sql } from 'drizzle-orm'
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

export async function listParticipants(page: number) {
  const db = useDatabase()
  const stats = progressStats()
  const pageSize = 20
  const [items, totals] = await Promise.all([
    db.select({ id: participants.id, code: participants.code, initials: participants.initials,
      ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender, createdAt: participants.createdAt,
      openedSessions: sql<number>`coalesce(${stats.opened}, 0)`.mapWith(Number),
      completedSessions: sql<number>`coalesce(${stats.completed}, 0)`.mapWith(Number),
      lastLearningActivityAt: stats.lastActivity
    }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id))
      .orderBy(desc(participants.createdAt), desc(participants.id)).limit(pageSize).offset((page - 1) * pageSize),
    db.select({ total: count() }).from(participants)
  ])
  return { items, page, pageSize, total: totals[0]?.total ?? 0 }
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
