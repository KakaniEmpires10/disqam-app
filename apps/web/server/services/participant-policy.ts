import { createHmac, randomInt } from 'node:crypto'
import { AuthError, validToken } from './auth-policy'

export const PARTICIPANT_SESSION_SECONDS = 90 * 24 * 60 * 60
export const PROGRAM_SESSIONS = [
  { id: 'session-1', number: 1, title: 'Sesi I · Kenali Masalah Tidur' },
  { id: 'session-2', number: 2, title: 'Sesi II · Stimulus Control' },
  { id: 'session-3', number: 3, title: 'Sesi III · Pengaturan Waktu Tidur' },
  { id: 'session-4', number: 4, title: 'Sesi IV · Tenangkan Pikiran' },
  { id: 'session-5', number: 5, title: 'Sesi V · Relaksasi' },
  { id: 'session-6', number: 6, title: 'Sesi VI · Buku Harian & Pemantauan' }
] as const

export function objectBody(value: unknown, allowed: string[]) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new AuthError(400, 'Data tidak valid.')
  const body = value as Record<string, unknown>
  if (Object.keys(body).some(key => !allowed.includes(key))) throw new AuthError(400, 'Ada kolom yang tidak dikenali.')
  return body
}

export function registrationInput(value: unknown) {
  const body = objectBody(value, ['initials', 'ageAtEnrollment', 'gender', 'registrationKey'])
  if (typeof body.initials !== 'string' || !/^[\p{L}. ]{1,10}$/u.test(body.initials.trim()) || !/\p{L}/u.test(body.initials)) {
    throw new AuthError(400, 'Masukkan inisial, maksimal 10 karakter.')
  }
  const initials = body.initials.trim().toUpperCase()
  if (Array.from(initials).length > 10) throw new AuthError(400, 'Masukkan inisial, maksimal 10 karakter.')
  const age = body.ageAtEnrollment ?? null
  if (age !== null && (typeof age !== 'number' || !Number.isInteger(age) || age < 0 || age > 130)) throw new AuthError(400, 'Usia tidak valid.')
  const gender = body.gender ?? null
  if (gender !== null && (typeof gender !== 'string' || !['male', 'female', 'unspecified'].includes(gender))) throw new AuthError(400, 'Pilihan jenis kelamin tidak valid.')
  if (!validToken(body.registrationKey)) throw new AuthError(400, 'Kunci pendaftaran tidak valid. Coba mulai kembali.')
  return { initials, ageAtEnrollment: age as number | null, gender: gender as string | null, registrationKey: body.registrationKey }
}

export function participantCode() {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
  return 'DQ-' + Array.from({ length: 10 }, () => alphabet[randomInt(alphabet.length)]).join('')
}

function base32(buffer: Buffer) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
  let bits = 0
  let value = 0
  let result = ''
  for (const byte of buffer) {
    value = (value << 8) | byte
    bits += 8
    while (bits >= 5) {
      result += alphabet[(value >>> (bits - 5)) & 31]
      bits -= 5
    }
  }
  if (bits > 0) result += alphabet[(value << (5 - bits)) & 31]
  return result
}

export function participantAccessCode(code: string, registrationKey: string, secret = process.env.NUXT_SESSION_PASSWORD) {
  if (!secret || secret.length < 32) throw new AuthError(503, 'Pendaftaran belum tersedia.')
  const verifier = base32(createHmac('sha256', secret)
    .update('disqam:participant-access-code:v1:' + registrationKey).digest()).slice(0, 12)
  return `${code}-${verifier}`
}

export function normalizeAccessCode(value: unknown) {
  if (typeof value !== 'string') throw new AuthError(400, 'Masukkan kode kepesertaan yang valid.')
  const normalized = value.trim().toUpperCase().replace(/[–—−]/g, '-').replace(/\s+/g, '')
  if (!/^DQ-[A-HJ-NP-Z2-9]{10}-[A-HJ-NP-Z2-9]{12}$/.test(normalized)) throw new AuthError(400, 'Masukkan kode kepesertaan yang valid.')
  return normalized
}

export function accessLoginInput(value: unknown) {
  const body = objectBody(value, ['accessCode'])
  return { accessCode: normalizeAccessCode(body.accessCode) }
}

// Server-derived opaque credential; stable only for retrying the original registration.
export function registrationAccessToken(key: string, secret = process.env.NUXT_SESSION_PASSWORD) {
  if (!secret || secret.length < 32) throw new AuthError(503, 'Pendaftaran belum tersedia.')
  return createHmac('sha256', secret).update('disqam:participant-registration:v1:' + key).digest('base64url')
}

export function progressInput(value: unknown) {
  const body = objectBody(value, ['sessionId', 'action'])
  const session = PROGRAM_SESSIONS.find(item => item.id === body.sessionId)
  if (!session || (body.action !== 'open' && body.action !== 'complete')) throw new AuthError(400, 'Sesi atau tindakan tidak valid.')
  return { sessionNumber: session.number, action: body.action as 'open' | 'complete' }
}

export type ProgressRecord = { sessionNumber: number, firstOpenedAt: Date, lastOpenedAt: Date, completedAt: Date | null }
export function progressSummary(rows: ProgressRecord[]) {
  const sessions = PROGRAM_SESSIONS.map((session) => {
    const row = rows.find(item => item.sessionNumber === session.number)
    return { ...session, status: row?.completedAt ? 'completed' : row ? 'in_progress' : 'not_started',
      firstOpenedAt: row?.firstOpenedAt ?? null, lastOpenedAt: row?.lastOpenedAt ?? null, completedAt: row?.completedAt ?? null }
  })
  const completedSessions = sessions.filter(item => item.status === 'completed').length
  return { sessions, completedSessions, totalSessions: 6, allLearningSessionsCompleted: completedSessions === 6 }
}
