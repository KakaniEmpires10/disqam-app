import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createRequire } from 'node:module'
import { dirname, join } from 'node:path'
import test from 'node:test'
import { getTableConfig } from 'drizzle-orm/pg-core'
import { requireDatabaseUrl } from '../server/db/environment'
import { participants, participantSessions, sleepDiaries, adminUsers, adminSessions, adminLoginLimits, participantProgress, participantRequestLimits } from '../server/db/schema'

test('schema contains identity, diary and admin/session/security tables', () => {
  assert.deepEqual([participants, participantSessions, sleepDiaries, adminUsers, adminSessions, adminLoginLimits, participantProgress, participantRequestLimits].map(t => getTableConfig(t).name),
    ['participants', 'participant_sessions', 'sleep_diaries', 'admin_users', 'admin_sessions', 'admin_login_limits', 'participant_progress', 'participant_request_limits'])
  const config = getTableConfig(sleepDiaries)
  const unique = config.indexes.find(i => i.config.name === 'sleep_diaries_participant_date_uidx')!
  assert.equal(unique.config.unique, true)
  assert.deepEqual(unique.config.columns.map(c => 'name' in c ? c.name : null), ['participant_id', 'sleep_date'])
  assert.equal(config.foreignKeys[0]!.onDelete, 'restrict')
  assert.equal(config.columns.some(c => ['score', 'se', 'tst', 'tib'].includes(c.name)), false)
  for (const name of ['nap_minutes', 'total_awake_minutes', 'night_awakenings']) {
    const column = config.columns.find(c => c.name === name)!
    assert.equal(column.notNull, false)
    assert.equal(column.hasDefault, false) // unknown must not silently become zero
  }
})

test('participants have no conventional account credentials', () => {
  const names = getTableConfig(participants).columns.map(c => c.name)
  for (const field of ['email', 'password', 'phone', 'full_name', 'nik']) assert.equal(names.includes(field), false)
  for (const table of [participantSessions, adminSessions]) {
    const columns = getTableConfig(table).columns
    assert.equal(columns.some(c => c.name === 'token'), false)
    assert.equal(columns.find(c => c.name === 'token_hash')!.primary, true)
    assert.equal(columns.find(c => c.name === 'expires_at')!.notNull, true)
  }
})

test('database configuration errors do not expose credentials', () => {
  assert.throws(() => requireDatabaseUrl(''), /belum diisi/)
  assert.throws(() => requireDatabaseUrl('https://admin:secret@example.com/db'), (error: unknown) => {
    assert.ok(error instanceof Error)
    assert.equal(error.message.includes('secret'), false)
    return true
  })
  assert.equal(requireDatabaseUrl('postgresql://user:password@localhost/disqam'), 'postgresql://user:password@localhost/disqam')
})

test('CLI guards fail before connecting to a database', () => {
  const require = createRequire(import.meta.url)
  const cli = join(dirname(require.resolve('drizzle-kit')), 'bin.cjs')
  const version = spawnSync(process.execPath, [cli, '--version'], { encoding: 'utf8' })
  assert.equal(version.status, 0, version.stderr)
  const run = (command: string, overrides: Record<string, string>) => spawnSync(process.execPath,
    [require.resolve('tsx/cli'), 'scripts/db.ts', command], {
      encoding: 'utf8', env: { ...process.env, DATABASE_URL: '', DATABASE_ENV: 'development', ...overrides }
    })
  const production = run('push', { NODE_ENV: 'production' })
  assert.equal(production.status, 1)
  assert.match(production.stderr, /hanya untuk development/)
  const missingUrl = run('push', { NODE_ENV: 'development' })
  assert.equal(missingUrl.status, 1)
  assert.match(missingUrl.stderr, /DATABASE_URL belum diisi/)
  const noMigration = run('migrate', {})
  assert.equal(noMigration.status, 1)
  assert.match(noMigration.stderr, /Belum ada migration/)
})
