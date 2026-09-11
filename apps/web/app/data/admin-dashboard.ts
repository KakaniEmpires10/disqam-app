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

export const dashboardMetrics: DashboardMetric[] = [
  { label: 'Total peserta', value: '48', note: 'terdaftar', icon: 'i-lucide-users-round', tone: 'primary' },
  { label: 'Peserta aktif', value: '32', note: 'beraktivitas 14 hari terakhir', icon: 'i-lucide-activity', tone: 'success' },
  { label: 'Sedang mengikuti program', value: '27', note: 'minimal satu sesi dibuka', icon: 'i-lucide-route', tone: 'accent' },
  { label: 'Program selesai', value: '11', note: 'enam sesi ditandai selesai', icon: 'i-lucide-circle-check', tone: 'neutral' }
]

export const sessionProgress: SessionProgress[] = [
  { session: 'I', title: 'Masalah tidur & sleep hygiene', completed: 38, opened: 45, total: 48 },
  { session: 'II', title: 'Stimulus control', completed: 32, opened: 41, total: 48 },
  { session: 'III', title: 'Sleep scheduling', completed: 27, opened: 36, total: 48 },
  { session: 'IV', title: 'Cognitive restructuring', completed: 22, opened: 31, total: 48 },
  { session: 'V', title: 'Relaksasi', completed: 17, opened: 25, total: 48 },
  { session: 'VI', title: 'Sleep diary & monitoring', completed: 11, opened: 18, total: 48 }
]

export const recentActivity = [
  { code: 'DQ-K72MP', initials: 'MAK', event: 'menandai Sesi III selesai', time: 'Hari ini, 09.24', tone: 'success' },
  { code: 'DQ-R18TZ', initials: 'SRI', event: 'membuka Sesi II', time: 'Hari ini, 08.47', tone: 'primary' },
  { code: 'DQ-P44NX', initials: 'BDS', event: 'mengisi sleep diary', time: 'Kemarin, 19.10', tone: 'accent' },
  { code: 'DQ-H91QC', initials: 'NUR', event: 'membuka Sesi I', time: 'Kemarin, 16.32', tone: 'primary' }
]

export const diarySummary = {
  totalEntries: 186,
  activeParticipants: 29,
  lastSevenDays: 73,
  note: 'Ringkasan aktivitas pencatatan, bukan penilaian klinis.'
}
