import { count, desc, eq, sql } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participants, participantProgress } from '../db/schema'
import { AuthError } from './auth-policy'
import { readProgress } from './program-progress'
import { objectBody } from './participant-policy'

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

export async function participantDetail(value: unknown) {
  const body = objectBody(value, ['participantId'])
  if (typeof body.participantId !== 'string' || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(body.participantId)) throw new AuthError(400, 'Peserta tidak valid.')
  const [participant] = await useDatabase().select({ id: participants.id, code: participants.code, initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment, gender: participants.gender, createdAt: participants.createdAt
  }).from(participants).where(eq(participants.id, body.participantId)).limit(1)
  if (!participant) throw new AuthError(404, 'Peserta tidak ditemukan.')
  return { participant, progress: await readProgress(participant.id) }
}
