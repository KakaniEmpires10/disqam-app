import { createHash, randomBytes } from 'node:crypto'

export const SESSION_SECONDS = 7 * 24 * 60 * 60
export class AuthError extends Error {
  constructor(public status: number, message: string) { super(message) }
}
export function normalizeEmail(value: unknown) {
  if (typeof value !== 'string' || value.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim())) {
    throw new AuthError(400, 'Masukkan alamat email yang valid.')
  }
  return value.trim().toLowerCase()
}
export function validatePassword(value: unknown, creating = false): string {
  if (typeof value !== 'string' || value.length < (creating ? 12 : 1) || value.length > 128) {
    throw new AuthError(400, creating ? 'Password harus terdiri dari 12–128 karakter.' : 'Masukkan password yang valid.')
  }
  return value
}
export function tokenHash(token: string) {
  return createHash('sha256').update(token).digest('hex')
}
export function newToken() {
  return randomBytes(32).toString('base64url')
}
export function validToken(value: unknown): value is string {
  return typeof value === 'string' && /^[A-Za-z0-9_-]{43}$/.test(value)
}
export function checkOrigin(origin: string | undefined, configured: string | undefined) {
  if (!configured) throw new AuthError(503, 'Layanan login belum tersedia.')
  let expected: URL
  try {
    expected = new URL(configured)
  } catch {
    throw new AuthError(503, 'Layanan login belum tersedia.')
  }
  if (!['http:', 'https:'].includes(expected.protocol) || (process.env.NODE_ENV === 'production' && expected.protocol !== 'https:')) {
    throw new AuthError(503, 'Layanan login belum tersedia.')
  }
  if (origin !== expected.origin) throw new AuthError(403, 'Permintaan tidak diizinkan.')
}
