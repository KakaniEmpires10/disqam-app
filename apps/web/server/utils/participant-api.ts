import type { H3Event } from 'h3'
import { AuthError, validToken } from '../services/auth-policy'
import { readAuthBody } from '../services/auth-body'
import { resolveParticipant } from '../services/participants'

// Versioned so browser sessions created before the diary access policy change are ignored.
const PARTICIPANT_COOKIE = 'disqam-participant-v2'
export async function readParticipantBody(event: H3Event) {
  if (getHeader(event, 'content-type')?.split(';')[0]?.trim() !== 'application/json') throw new AuthError(415, 'Gunakan format JSON.')
  const raw = await readAuthBody(event)
  try {
    return JSON.parse(raw) as unknown
  } catch {
    throw new AuthError(400, 'Data tidak valid.')
  }
}

export function participantToken(event: H3Event) {
  const authorization = getHeader(event, 'authorization')
  if (authorization !== undefined) {
    const token = authorization.startsWith('Bearer ') ? authorization.slice(7) : ''
    if (!validToken(token)) throw new AuthError(401, 'Akses peserta tidak valid.')
    return token
  }
  return getCookie(event, PARTICIPANT_COOKIE)
}

export function participantWriteGuard(event: H3Event) {
  if (getHeader(event, 'authorization') !== undefined) assertAuthRequest(event, true)
  else assertBrowserOrigin(event)
}

export async function requireParticipant(event: H3Event) {
  if (!['GET', 'HEAD'].includes(event.method)) participantWriteGuard(event)
  return resolveParticipant(participantToken(event))
}

export function setParticipantCookie(event: H3Event, token: string, expiresAt: Date) {
  setCookie(event, PARTICIPANT_COOKIE, token, { httpOnly: true, secure: process.env.NODE_ENV === 'production', sameSite: 'strict', path: '/', expires: expiresAt })
}
export function clearParticipantCookie(event: H3Event) {
  deleteCookie(event, PARTICIPANT_COOKIE, { path: '/' })
}
