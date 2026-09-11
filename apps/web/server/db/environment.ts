export function requireDatabaseUrl(value: string | undefined = process.env.DATABASE_URL): string {
  const url = value?.trim()
  if (!url) throw new Error('DATABASE_URL belum diisi. Atur di apps/web/.env atau environment server.')
  try {
    const parsed = new URL(url)
    if (!['postgres:', 'postgresql:'].includes(parsed.protocol) || !parsed.hostname || parsed.pathname.length < 2) {
      throw new Error('Invalid database URL')
    }
  } catch {
    // Do not echo a URL containing credentials into errors/logs.
    throw new Error('DATABASE_URL harus berupa URL PostgreSQL yang valid.')
  }
  return url
}
