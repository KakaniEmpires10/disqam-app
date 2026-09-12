import { AuthError } from './auth-policy'

const MAX_AUTH_BODY_BYTES = 4096

export function validateAuthBodySize(raw: string) {
  if (Buffer.byteLength(raw) > MAX_AUTH_BODY_BYTES) {
    throw new AuthError(413, 'Data permintaan terlalu besar.')
  }
  return raw
}

// Use H3's body reader so serverless adapters can return an already-buffered
// request body. Listening to event.node.req directly can miss the `end` event.
export async function readAuthBody(event: Parameters<typeof readRawBody>[0]) {
  const declaredLength = Number(getHeader(event, 'content-length'))
  if (Number.isFinite(declaredLength) && declaredLength > MAX_AUTH_BODY_BYTES) {
    throw new AuthError(413, 'Data permintaan terlalu besar.')
  }
  return validateAuthBodySize((await readRawBody(event)) ?? '')
}
