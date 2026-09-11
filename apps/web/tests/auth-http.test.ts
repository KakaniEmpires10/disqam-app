import assert from 'node:assert/strict'
import { spawn } from 'node:child_process'
import { randomBytes } from 'node:crypto'
import { once } from 'node:events'
import { existsSync } from 'node:fs'
import { createServer } from 'node:net'
import { setTimeout } from 'node:timers/promises'
import test from 'node:test'

test('built auth HTTP endpoints fail closed without a database', { timeout: 30000 }, async () => {
  assert.ok(existsSync('.output/server/index.mjs'), 'Jalankan pnpm run build terlebih dahulu.')
  const socket = createServer()
  socket.listen(0, '127.0.0.1')
  await once(socket, 'listening')
  const address = socket.address()
  assert.ok(address && typeof address === 'object')
  const port = address.port
  await new Promise<void>(resolve => socket.close(() => resolve()))
  const baseUrl = `http://127.0.0.1:${port}`
  // Production bundle enforces HTTPS for the browser origin, even on a local socket.
  const origin = 'https://disqam.test'
  const server = spawn(process.execPath, ['.output/server/index.mjs'], {
    stdio: 'ignore', windowsHide: true,
    env: { ...process.env, NODE_ENV: 'development', PORT: String(port), NITRO_PORT: String(port), HOST: '127.0.0.1', NITRO_HOST: '127.0.0.1',
      DATABASE_URL: '', APP_URL: origin, NUXT_SESSION_PASSWORD: randomBytes(32).toString('hex') }
  })
  try {
    let ready = false
    for (let attempt = 0; attempt < 80; attempt++) {
      try {
        await fetch(`${baseUrl}/api/admin/auth/me`)
        ready = true
        break
      } catch {
        await setTimeout(100)
      }
    }
    assert.ok(ready, 'Server test tidak berhasil dimulai.')
    const request = async (path: string, status: number, options: RequestInit = {}) => {
      const response = await fetch(`${baseUrl}/api/admin/auth/${path}`, options)
      assert.equal(response.status, status, path)
      assert.equal(response.headers.get('cache-control'), 'no-store')
      const body = await response.json() as { success: boolean, message?: string }
      assert.equal(body.success, status < 400)
      if (status >= 400) {
        assert.equal(typeof body.message, 'string')
        assert.equal(JSON.stringify(body).includes('DATABASE_URL'), false)
        assert.equal(JSON.stringify(body).includes('stack'), false)
      }
    }
    await request('me', 401)
    await request('me', 401, { headers: { authorization: 'Bearer invalid' } })
    await request('login', 403, { method: 'POST', headers: { origin: 'https://evil.example' } })
    await request('token', 403, { method: 'POST', headers: { origin } })
    await request('token', 403, { method: 'POST', headers: { cookie: 'anything=1' } })
    await request('token', 415, { method: 'POST', body: '{}' })
    await request('token', 400, { method: 'POST', headers: { 'content-type': 'application/json' }, body: '{invalid' })
    await request('token', 413, { method: 'POST', headers: { 'content-type': 'application/json' }, body: 'x'.repeat(5000) })
    await request('token', 503, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ email: 'test@example.com', password: 'test-only-password' }) })
    await request('logout', 403, { method: 'POST', headers: { origin: 'https://evil.example' } })
    await request('logout', 200, { method: 'POST', headers: { origin } })
    await request('logout-all', 401, { method: 'POST', headers: { origin } })

    const participantRequest = async (path: string, status: number, options: RequestInit = {}) => {
      const response = await fetch(`${baseUrl}/api/${path}`, options)
      assert.equal(response.status, status, path)
      assert.equal(response.headers.get('cache-control'), 'no-store')
      const body = await response.json() as { success: boolean, message?: string }
      assert.equal(body.success, status < 400)
      assert.equal(JSON.stringify(body).includes('DATABASE_URL'), false)
      assert.equal(JSON.stringify(body).includes('stack'), false)
    }
    await participantRequest('participant/me', 401)
    await participantRequest('participant/progress', 401)
    await participantRequest('participant/progress', 401, { method: 'POST', headers: { origin } })
    await participantRequest('participant/progress', 403, { method: 'POST', headers: { origin: 'https://evil.example' } })
    await participantRequest('participant/register', 403, { method: 'POST', headers: { origin: 'https://evil.example' } })
    await participantRequest('participant/register', 400, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ initials: 'AB', participantId: 'spoofed' }) })
    await participantRequest('participant/register', 503, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ initials: 'AB', registrationKey: randomBytes(32).toString('base64url') }) })
    await participantRequest('participant/login', 400, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ accessCode: 'DQ-SALAH' }) })
    await participantRequest('participant/login', 503, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ accessCode: 'DQ-ABCDEFGHJK-ABCDEFGHJKLM' }) })
    await participantRequest('admin/participants', 401)
    await participantRequest('admin/participants/summary', 401)
    await participantRequest('admin/participants/detail', 401, { method: 'POST', headers: { origin } })
  } finally {
    if (server.exitCode === null) {
      const exited = once(server, 'exit')
      server.kill()
      await exited
    }
  }
})
