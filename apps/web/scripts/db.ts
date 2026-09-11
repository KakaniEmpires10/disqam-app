import 'dotenv/config'
import { spawnSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { createRequire } from 'node:module'
import { dirname, join } from 'node:path'
import { requireDatabaseUrl } from '../server/db/environment'

const command = process.argv[2]
try {
  if (!['push', 'migrate', 'generate'].includes(command ?? '')) {
    throw new Error('Gunakan db:push, db:migrate, atau db:generate.')
  }
  if (command === 'push' && (process.env.NODE_ENV === 'production' || process.env.DATABASE_ENV !== 'development')) {
    throw new Error('db:push hanya untuk development. Set DATABASE_ENV=development dan pastikan URL bukan database produksi.')
  }
  if (command === 'migrate' && !existsSync('./drizzle/meta/_journal.json')) {
    throw new Error('Belum ada migration. Gunakan db:push saat development; buat baseline dengan db:generate sebelum rilis produksi pertama.')
  }
  if (command !== 'generate') requireDatabaseUrl()
  const require = createRequire(import.meta.url)
  const cli = join(dirname(require.resolve('drizzle-kit')), 'bin.cjs')
  const result = spawnSync(process.execPath, [cli, command!, '--config=drizzle.config.ts'], {
    stdio: 'inherit',
    env: process.env
  })
  if (result.error) throw new Error('Drizzle Kit tidak dapat dijalankan. Periksa instalasi dependency.')
  process.exitCode = result.status ?? 1
} catch (error) {
  console.error(error instanceof Error ? error.message : 'Perintah database gagal.')
  process.exitCode = 1
}
