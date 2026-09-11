declare module '#auth-utils' {
  interface User { email: string }
  interface SecureSessionData { adminToken?: string }
}

export {}
