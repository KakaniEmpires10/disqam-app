import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'
import { getTableConfig } from 'drizzle-orm/pg-core'
import { participantProgress, participants } from '../server/db/schema'
import { AuthError, newToken } from '../server/services/auth-policy'
import { accessLoginInput, normalizeAccessCode, participantAccessCode, participantCode, progressInput, progressSummary, PROGRAM_SESSIONS, registrationAccessToken, registrationInput } from '../server/services/participant-policy'
import { sleepDiaryInput } from '../server/services/sleep-diary'

test('sleep diary accepts the normalized daily contract and rejects unsafe values', () => {
  const input = sleepDiaryInput({ sleepDate: '2026-09-10', bedTime: '21:30', sleepStartTime: '22:00', nightAwakenings: 2, totalAwakeMinutes: 30, finalWakeTime: '05:30', outOfBedTime: '06:00', napMinutes: 45 })
  assert.equal(input.sleepDate, '2026-09-10')
  assert.equal(input.nightAwakenings, 2)
  for (const invalid of [{ sleepDate: '10-09-2026' }, { sleepDate: '2026-02-30' }, { bedTime: '25:00' }, { totalAwakeMinutes: -1 }, { napMinutes: 1441 }]) {
    assert.throws(() => sleepDiaryInput({ sleepDate: '2026-09-10', bedTime: '21:30', finalWakeTime: '05:30', outOfBedTime: '06:00', ...invalid }), AuthError)
  }
})

test('registration only accepts minimal pseudonymous data and secure retry key', () => {
  const input = { initials: ' ab ', registrationKey: newToken() }
  assert.deepEqual(registrationInput(input), { initials: 'AB', ageAtEnrollment: null, gender: null, registrationKey: input.registrationKey })
  for (const extra of [{ initials: '   ' }, { initials: '..' }, { initials: 'ABCDEFGHIJK' }, { ageAtEnrollment: '70' },
    { ageAtEnrollment: 70.5 }, { ageAtEnrollment: -1 }, { gender: ['male'] }, { email: 'test@example.com' },
    { participantId: 'fake' }, { registrationKey: 'DQ-ABCDEFGH' }, { createdAt: new Date() }]) {
    assert.throws(() => registrationInput({ ...input, ...extra }), AuthError)
  }
})

test('participant codes are pseudonymous and retry credentials are server-derived', () => {
  const codes = new Set(Array.from({ length: 100 }, participantCode))
  assert.equal(codes.size, 100)
  for (const code of codes) assert.match(code, /^DQ-[A-HJ-NP-Z2-9]{10}$/)
  const key = newToken()
  const secret = 'test-only-secret'.repeat(3)
  assert.equal(registrationAccessToken(key, secret), registrationAccessToken(key, secret))
  assert.notEqual(registrationAccessToken(key, secret), key)
  assert.notEqual(registrationAccessToken(key, secret), registrationAccessToken(newToken(), secret))
  assert.throws(() => registrationAccessToken(key, ''), AuthError)
  const accessCode = participantAccessCode('DQ-ABCDEFGHJK', key, secret)
  assert.match(accessCode, /^DQ-[A-HJ-NP-Z2-9]{10}-[A-HJ-NP-Z2-9]{12}$/)
  assert.equal(participantAccessCode('DQ-ABCDEFGHJK', key, secret), accessCode)
  assert.equal(normalizeAccessCode(`  ${accessCode.toLowerCase()}  `), accessCode)
  assert.deepEqual(accessLoginInput({ accessCode }), { accessCode })
  for (const invalid of ['', 'DQ-ABCDEFGHJK', accessCode + 'A', accessCode.replace('A', 'I')]) {
    assert.throws(() => normalizeAccessCode(invalid), AuthError)
  }
  assert.throws(() => accessLoginInput({ accessCode, initials: 'AB' }), AuthError)
})

test('all six sessions allow explicit open/complete; arbitrary status and timestamps rejected', () => {
  for (const session of PROGRAM_SESSIONS) {
    assert.deepEqual(progressInput({ sessionId: session.id, action: 'open' }), { sessionNumber: session.number, action: 'open' })
    assert.equal(progressInput({ sessionId: session.id, action: 'complete' }).sessionNumber, session.number)
  }
  for (const body of [{ sessionId: 'session-7', action: 'open' }, { sessionId: 'session-1', action: 'reset' },
    { sessionId: 'session-1', action: 'complete', completedAt: '2026-01-01' },
    { sessionId: 'session-1', action: 'open', participantId: newToken() }, { status: 'completed' }]) {
    assert.throws(() => progressInput(body), AuthError)
  }
})

test('opened is not completed; summaries always contain six sessions', () => {
  const empty = progressSummary([])
  assert.equal(empty.sessions.length, 6)
  assert.equal(empty.completedSessions, 0)
  assert.equal(empty.allLearningSessionsCompleted, false)
  const now = new Date()
  const rows = [{ sessionNumber: 6, firstOpenedAt: now, lastOpenedAt: now, completedAt: null }]
  assert.equal(progressSummary(rows).sessions[5]!.status, 'in_progress')
  const completed = progressSummary(PROGRAM_SESSIONS.map(session => ({ sessionNumber: session.number, firstOpenedAt: now, lastOpenedAt: now, completedAt: now })))
  assert.equal(completed.completedSessions, 6)
  assert.equal(completed.allLearningSessionsCompleted, true)
})

test('schema prevents duplicate progress and registration retries', () => {
  const progress = getTableConfig(participantProgress)
  assert.deepEqual(progress.primaryKeys[0]!.columns.map(column => column.name), ['participant_id', 'session_number'])
  assert.equal(progress.foreignKeys[0]!.onDelete, 'restrict')
  assert.ok(progress.checks.find(item => item.name === 'participant_progress_session_range'))
  assert.ok(getTableConfig(participants).indexes.find(item => item.config.name === 'participants_registration_key_uidx')?.config.unique)
  assert.ok(getTableConfig(participants).indexes.find(item => item.config.name === 'participants_access_code_uidx')?.config.unique)
})

test('server catalog uses the exact mobile session IDs and titles', () => {
  const mobile = readFileSync('../mobile/lib/content/program.dart', 'utf8')
  for (const session of PROGRAM_SESSIONS) {
    assert.ok(mobile.includes(`id: '${session.id}'`))
    assert.ok(mobile.includes(`title: '${session.title}'`))
  }
})
