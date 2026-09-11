import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createRequire } from 'node:module'
import test from 'node:test'
import { Readable } from 'node:stream'
import type { IncomingMessage } from 'node:http'
import { readAuthBody } from '../server/services/auth-body'
import { Scrypt } from '@adonisjs/hash/drivers/scrypt'
import { AuthError, checkOrigin, newToken, normalizeEmail, SESSION_SECONDS, tokenHash, validatePassword, validToken } from '../server/services/auth-policy'

test('email normalization and password validation', () => {
  assert.equal(normalizeEmail(' Admin@Example.com '), 'admin@example.com')
  for (const value of [null, {}, '', 'admin', 'a@b', 'a b@example.com']) assert.throws(() => normalizeEmail(value), AuthError)
  assert.throws(() => validatePassword('short', true), AuthError)
  assert.throws(() => validatePassword('x'.repeat(129)), AuthError)
  assert.equal(validatePassword(' correct horse battery ', true), ' correct horse battery ')
})

test('opaque tokens are random and stored only as SHA-256 digests', () => {
  const first = newToken()
  assert.ok(validToken(first))
  assert.notEqual(first, newToken())
  assert.match(tokenHash(first), /^[a-f0-9]{64}$/)
  assert.notEqual(tokenHash(first), first)
  for (const value of [undefined, '', 'Bearer ' + first, first + '\n', 'a'.repeat(64)]) assert.equal(validToken(value), false)
  assert.equal(SESSION_SECONDS, 604800)
})

test('browser writes require exact configured origin', () => {
  checkOrigin('https://disqam.example', 'https://disqam.example')
  for (const origin of [undefined, 'null', 'https://evil.example', 'https://disqam.example.evil', 'http://disqam.example']) {
    assert.throws(() => checkOrigin(origin, 'https://disqam.example'), AuthError)
  }
  assert.throws(() => checkOrigin('https://disqam.example', undefined), AuthError)
})

test('request buffering rejects oversized chunked input', async () => {
  const request = (parts: string[]) => Readable.from(parts) as unknown as IncomingMessage
  assert.equal(await readAuthBody(request(['{"email":', '"a@example.com"}'])), '{"email":"a@example.com"}')
  await assert.rejects(readAuthBody(request(['a'.repeat(3000), 'b'.repeat(3000)])), (error: unknown) => error instanceof AuthError && error.status === 413)
})

test('provisioning hash is verified by the same Scrypt driver as Nuxt Auth Utils', async () => {
  const cli = new Scrypt({})
  const runtime = new Scrypt({})
  const password = 'test-only passphrase 123!'
  const hash = await cli.make(password)
  assert.notEqual(hash, password)
  assert.equal(await runtime.verify(hash, password), true)
  assert.equal(await runtime.verify(hash, 'incorrect'), false)
})

test('admin creation refuses non-interactive password arguments before database access', () => {
  const require = createRequire(import.meta.url)
  const result = spawnSync(process.execPath, [require.resolve('tsx/cli'), 'scripts/admin-create.ts', '--password=test'], {
    encoding: 'utf8', env: { ...process.env, DATABASE_URL: '' }
  })
  assert.equal(result.status, 1)
  assert.match(result.stderr, /terminal interaktif/)
  assert.equal(result.stderr.includes('--password=test'), false)
})

test('admin password reset refuses non-interactive password arguments before database access', () => {
  const require = createRequire(import.meta.url)
  const result = spawnSync(process.execPath, [require.resolve('tsx/cli'), 'scripts/admin-reset-password.ts', '--password=test'], {
    encoding: 'utf8', env: { ...process.env, DATABASE_URL: '' }
  })
  assert.equal(result.status, 1)
  assert.match(result.stderr, /terminal interaktif/)
  assert.equal(result.stderr.includes('--password=test'), false)
})
