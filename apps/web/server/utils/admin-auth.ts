import type { H3Event } from 'h3'
import { AuthError, checkOrigin, normalizeEmail, validatePassword } from '../services/auth-policy'
import { resolveAdmin } from '../services/admin-auth'
import { readAuthBody } from '../services/auth-body'

export function assertBrowserOrigin(event: H3Event) {
  checkOrigin(getHeader(event, 'origin'), process.env.APP_URL)
}
export function assertAuthRequest(event: H3Event, mobile = false) {
  if (mobile) {
    // Native clients have no Origin or browser cookies. Never allow cookie fallback.
    if (getHeader(event, 'origin') || getHeader(event, 'cookie')) throw new AuthError(403, 'Permintaan tidak diizinkan.')
  } else assertBrowserOrigin(event)
}
export async function readCredentials(event: H3Event) {
  if (getHeader(event, 'content-type')?.split(';')[0]?.trim() !== 'application/json') throw new AuthError(415, 'Gunakan format JSON.')
  let body: unknown
  const raw = await readAuthBody(event.node.req)
  if (!raw || Buffer.byteLength(raw) > 4096) throw new AuthError(413, 'Data login terlalu besar atau kosong.')
  try {
    body = JSON.parse(raw)
  } catch {
    throw new AuthError(400, 'Data login tidak valid.')
  }
  if (!body || typeof body !== 'object' || Array.isArray(body)) throw new AuthError(400, 'Data login tidak valid.')
  const value = body as Record<string, unknown>
  return { email: normalizeEmail(value.email), password: validatePassword(value.password) }
}
export async function getAdminToken(event: H3Event) {
  const authorization = getHeader(event, 'authorization')
  if (authorization !== undefined) {
    if (!/^Bearer [A-Za-z0-9_-]{43}$/.test(authorization)) throw new AuthError(401, 'Silakan login sebagai admin.')
    return authorization.slice(7)
  }
  return (await getUserSession(event)).secure?.adminToken
}
// Use this for EVERY protected admin endpoint, not requireUserSession alone.
export async function requireAdmin(event: H3Event) {
  if (!['GET', 'HEAD'].includes(event.method)) {
    if (getHeader(event, 'authorization')) assertAuthRequest(event, true)
    else assertBrowserOrigin(event)
  }
  return resolveAdmin(await getAdminToken(event))
}
export function adminEndpoint<T>(handler: (event: H3Event) => Promise<T>) {
  return defineEventHandler(async (event) => {
    setHeader(event, 'Cache-Control', 'no-store')
    try {
      return { success: true, data: await handler(event) }
    } catch (error) {
      const status = error instanceof AuthError ? error.status : 503
      setResponseStatus(event, status)
      if (status === 429) setHeader(event, 'Retry-After', 900)
      return { success: false, message: error instanceof AuthError ? error.message : 'Layanan belum dapat diakses. Silakan coba lagi.' }
    }
  })
}
