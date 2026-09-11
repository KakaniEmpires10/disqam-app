import type { IncomingMessage } from 'node:http'
import { AuthError } from './auth-policy'

// Cap buffered bytes even for chunked requests with no Content-Length.
export function readAuthBody(request: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    let size = 0
    const chunks: Buffer[] = []
    const cleanup = () => {
      request.off('data', onData)
      request.off('end', onEnd)
      request.off('error', onError)
      request.off('aborted', onAbort)
    }
    const onError = () => {
      cleanup()
      reject(new AuthError(400, 'Data permintaan tidak valid.'))
    }
    const onAbort = () => onError()
    const onEnd = () => {
      cleanup()
      resolve(Buffer.concat(chunks).toString('utf8'))
    }
    const onData = (chunk: Buffer | string) => {
      const bytes = Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk)
      size += bytes.length
      if (size > 4096) {
        cleanup()
        // Drain without buffering, so the server can still send a JSON 413.
        request.resume()
        reject(new AuthError(413, 'Data permintaan terlalu besar.'))
        return
      }
      chunks.push(bytes)
    }
    request.on('data', onData)
    request.once('end', onEnd)
    request.once('error', onError)
    request.once('aborted', onAbort)
  })
}
