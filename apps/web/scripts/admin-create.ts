import 'dotenv/config'
import { createInterface } from 'node:readline/promises'
import { emitKeypressEvents } from 'node:readline'
import { Scrypt } from '@adonisjs/hash/drivers/scrypt'
import { useDatabase } from '../server/db'
import { adminUsers } from '../server/db/schema'
import { AuthError, normalizeEmail, validatePassword } from '../server/services/auth-policy'

function secret(prompt: string): Promise<string> {
  process.stdout.write(prompt)
  emitKeypressEvents(process.stdin)
  process.stdin.setRawMode(true)
  process.stdin.resume()
  return new Promise((resolve, reject) => {
    let value = ''
    const finish = () => {
      process.stdin.off('keypress', listener)
      process.stdin.setRawMode(false)
      process.stdin.pause()
      process.stdout.write('\n')
    }
    const listener = (text: string, key: { name?: string, ctrl?: boolean }) => {
      if (key?.ctrl && key.name === 'c') {
        finish()
        reject(new AuthError(400, 'Dibatalkan.'))
        return
      }
      if (key?.name === 'return') {
        finish()
        resolve(value)
        return
      }
      if (key?.name === 'backspace') value = Array.from(value).slice(0, -1).join('')
      else if (text && !key?.ctrl && Array.from(text).every(char => char.charCodeAt(0) >= 32 && char.charCodeAt(0) !== 127)) value += text
    }
    process.stdin.on('keypress', listener)
  })
}

try {
  if (!process.stdin.isTTY || !process.stdout.isTTY || process.argv.length > 2) throw new AuthError(400, 'Jalankan pnpm run admin:create di terminal interaktif, tanpa argumen password.')
  const reader = createInterface({ input: process.stdin, output: process.stdout })
  let email: string
  try {
    email = normalizeEmail(await reader.question('Email admin: '))
  } finally {
    reader.close()
  }
  const password = validatePassword(await secret('Password (12–128 karakter, tidak ditampilkan): '), true)
  if (password !== await secret('Ulangi password: ')) throw new AuthError(400, 'Konfirmasi password tidak sama.')
  // Same driver and defaults as nuxt-auth-utils; no runtime Nuxt aliases in a CLI.
  const passwordHash = await new Scrypt({}).make(password)
  const created = await useDatabase().insert(adminUsers).values({ email, passwordHash })
    .onConflictDoNothing({ target: adminUsers.email }).returning({ id: adminUsers.id })
  if (!created.length) throw new AuthError(409, 'Email sudah terdaftar. Akun yang ada tidak diubah.')
  console.info('Akun admin berhasil dibuat.')
} catch (error) {
  console.error(error instanceof AuthError ? error.message : 'Akun belum berhasil dibuat. Periksa konfigurasi dan koneksi database.')
  process.exitCode = 1
}
