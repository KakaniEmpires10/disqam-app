import { neon } from '@neondatabase/serverless'
import { drizzle } from 'drizzle-orm/neon-http'
import { requireDatabaseUrl } from './environment'
import * as schema from './schema'

function createDatabase() {
  return drizzle(neon(requireDatabaseUrl()), { schema })
}

let database: ReturnType<typeof createDatabase> | undefined

// Lazy, server-only: static pages can build/render without DATABASE_URL.
// Future API services must authenticate ownership before using this client.
export function useDatabase() {
  database ??= createDatabase()
  return database
}
