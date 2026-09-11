export type DashboardMetric = {
  label: string
  value: string
  note: string
  icon: string
  tone: 'primary' | 'accent' | 'success' | 'neutral'
}

export type SessionProgress = {
  session: string
  title: string
  completed: number
  opened: number
  total: number
}
