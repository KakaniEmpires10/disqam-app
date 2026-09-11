import { and, eq, sql } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participantProgress } from '../db/schema'
import { AuthError } from './auth-policy'
import { progressSummary, type progressInput } from './participant-policy'

export async function readProgress(participantId: string) {
  const rows = await useDatabase().select().from(participantProgress).where(eq(participantProgress.participantId, participantId))
  return progressSummary(rows)
}

export async function recordProgress(participantId: string, input: ReturnType<typeof progressInput>) {
  const db = useDatabase()
  const table = participantProgress
  if (input.action === 'open') {
    await db.insert(table).values({ participantId, sessionNumber: input.sessionNumber })
      .onConflictDoUpdate({ target: [table.participantId, table.sessionNumber], set: { lastOpenedAt: sql`greatest(${table.lastOpenedAt}, now())` } })
  } else {
    const rows = await db.update(table).set({ completedAt: sql`coalesce(${table.completedAt}, greatest(${table.firstOpenedAt}, now()))` })
      .where(and(eq(table.participantId, participantId), eq(table.sessionNumber, input.sessionNumber)))
      .returning({ sessionNumber: table.sessionNumber })
    if (!rows.length) throw new AuthError(409, 'Buka sesi terlebih dahulu sebelum menandainya selesai.')
  }
  return readProgress(participantId)
}
