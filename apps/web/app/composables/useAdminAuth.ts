export type AdminUser = { email: string }
type AuthStatus = 'unknown' | 'loading' | 'authenticated' | 'unauthenticated' | 'error'

export function useAdminAuth() {
  const user = useState<AdminUser | null>('admin-user', () => null)
  const status = useState<AuthStatus>('admin-auth-status', () => 'unknown')
  const error = useState<string | null>('admin-auth-error', () => null)
  const api = useRequestFetch()

  async function load() {
    if (status.value === 'loading') return user.value
    status.value = 'loading'
    error.value = null
    try {
      const response = await api<{ data: { user: AdminUser } }>('/api/admin/auth/me')
      user.value = response.data.user
      status.value = 'authenticated'
    } catch (cause: unknown) {
      user.value = null
      const response = cause && typeof cause === 'object' ? (cause as { response?: { status?: number } }).response : undefined
      status.value = response?.status === 401 ? 'unauthenticated' : 'error'
      error.value = response?.status === 401 ? 'Sesi admin belum aktif.' : 'Sesi admin belum dapat diperiksa.'
    }
    return user.value
  }

  async function login(email: string, password: string) {
    status.value = 'loading'
    error.value = null
    try {
      const response = await $fetch<{ data: { user: AdminUser } }>('/api/admin/auth/login', {
        method: 'POST',
        body: { email, password }
      })
      user.value = response.data.user
      status.value = 'authenticated'
      return user.value
    } catch {
      user.value = null
      status.value = 'unauthenticated'
      error.value = 'Login belum berhasil. Periksa koneksi lalu coba lagi.'
      throw new Error(error.value)
    }
  }

  async function logout() {
    try {
      await $fetch('/api/admin/auth/logout', { method: 'POST' })
    } finally {
      user.value = null
      status.value = 'unauthenticated'
      error.value = null
    }
  }

  return { user, status, error, load, login, logout }
}
