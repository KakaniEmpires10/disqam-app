<script setup lang="ts">
import type { DashboardMetric, SessionProgress } from '~/data/admin-dashboard'

definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type DashboardResponse = {
  summary: {
    totalParticipants: number
    activeParticipants: number
    startedLearning: number
    completedLearning: number
  }
  sessionProgress: SessionProgress[]
  diarySummary: {
    totalEntries: number
    activeParticipants: number
    lastSevenDays: number
    note: string
  }
  recentActivity: Array<{
    code: string
    initials: string
    event: string
    time: string
  }>
}

type ApiResponse<T> = { success: boolean, data: T }

const { data: dashboardResponse, status, error } = await useFetch<ApiResponse<DashboardResponse>>('/api/admin/dashboard')
const dashboard = computed(() => dashboardResponse.value?.data)
const isLoading = computed(() => status.value === 'pending')
const totalParticipants = computed(() => dashboard.value?.summary.totalParticipants ?? 0)
const dashboardMetrics = computed<DashboardMetric[]>(() => {
  const summary = dashboard.value?.summary
  return [
    { label: 'Total peserta', value: String(summary?.totalParticipants ?? 0), note: 'terdaftar', icon: 'i-lucide-users-round', tone: 'primary' },
    { label: 'Peserta aktif', value: String(summary?.activeParticipants ?? 0), note: 'beraktivitas 14 hari terakhir', icon: 'i-lucide-activity', tone: 'success' },
    { label: 'Sedang mengikuti program', value: String(summary?.startedLearning ?? 0), note: 'minimal satu sesi dibuka', icon: 'i-lucide-route', tone: 'accent' },
    { label: 'Program selesai', value: String(summary?.completedLearning ?? 0), note: 'enam sesi ditandai selesai', icon: 'i-lucide-circle-check', tone: 'neutral' }
  ]
})
const sessionProgress = computed(() => dashboard.value?.sessionProgress ?? [])
const diarySummary = computed(() => dashboard.value?.diarySummary ?? { totalEntries: 0, activeParticipants: 0, lastSevenDays: 0, note: 'Belum ada catatan tidur.' })
const recentActivity = computed(() => dashboard.value?.recentActivity ?? [])

function progress(value: number) {
  return totalParticipants.value ? Math.round((value / totalParticipants.value) * 100) : 0
}
function formatActivityTime(value: string) {
  return new Intl.DateTimeFormat('id-ID', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
}
function toneClass(tone: string) {
  return {
    primary: 'bg-primary/10 text-primary',
    accent: 'bg-warning/10 text-warning',
    success: 'bg-success/10 text-success',
    neutral: 'bg-muted text-muted'
  }[tone] || 'bg-primary/10 text-primary'
}
</script>

<template>
  <div class="mx-auto max-w-[1440px] space-y-8">
    <div
      v-if="isLoading"
      class="space-y-6"
    >
      <USkeleton class="h-5 w-40" />
      <USkeleton class="h-12 w-full max-w-2xl" />
      <USkeleton class="h-6 w-full max-w-xl" />
      <USkeleton class="h-56 w-full rounded-[24px]" />
      <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <USkeleton
          v-for="item in 4"
          :key="item"
          class="h-40 rounded-2xl"
        />
      </div>
    </div>
    <UAlert
      v-else-if="error"
      color="error"
      variant="soft"
      title="Data dashboard belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />
    <template v-else>
      <header class="flex flex-col justify-between gap-4 md:flex-row md:items-end">
        <div>
          <p class="disqam-eyebrow">
            DASHBOARD ADMIN
          </p>
          <h1 class="mt-2 text-3xl font-bold tracking-tight text-highlighted md:text-4xl">
            Selamat datang di ruang monitoring.
          </h1>
          <p class="mt-3 max-w-2xl text-base leading-7 text-muted">
            Lihat perkembangan peserta dan aktivitas program DISQAM dalam satu pandangan yang tenang dan terarah.
          </p>
        </div>
        <div class="flex items-center gap-2 text-sm text-muted">
          <span class="size-2 rounded-full bg-success" /> Data dari database
        </div>
      </header>

      <section class="night-surface rounded-[24px] p-7 shadow-sm md:p-10">
        <div class="relative z-10 max-w-2xl">
          <p class="text-sm font-bold uppercase tracking-[0.15em] text-[#B5E5E9]">
            PEMANTAUAN PROGRAM
          </p>
          <h2 class="mt-4 text-3xl font-bold leading-tight text-white md:text-5xl">
            {{ totalParticipants }} peserta, satu perjalanan menuju tidur yang lebih baik.
          </h2>
          <p class="mt-5 max-w-xl text-base leading-7 text-[#D8E9EE]">
            Gunakan ringkasan ini untuk melihat ritme program. Detail peserta dan catatan tidur tersedia melalui menu di sisi kiri.
          </p>
          <div class="mt-7 flex flex-wrap gap-3">
            <UButton
              to="/admin/participants"
              color="primary"
              icon="i-lucide-users-round"
            >
              Lihat peserta
            </UButton>
            <UButton
              to="/admin/analytics"
              color="neutral"
              variant="soft"
              icon="i-lucide-route"
            >
              Lihat analitik
            </UButton>
          </div>
        </div>
      </section>

      <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <div
          v-for="metric in dashboardMetrics"
          :key="metric.label"
          class="soft-tile rounded-2xl p-5"
        >
          <div class="flex items-start justify-between gap-4">
            <p class="text-sm font-semibold text-muted">
              {{ metric.label }}
            </p>
            <span
              class="flex size-10 items-center justify-center rounded-xl"
              :class="toneClass(metric.tone)"
            ><UIcon
              :name="metric.icon"
              class="size-5"
            /></span>
          </div>
          <p class="mt-5 text-3xl font-bold text-highlighted">
            {{ metric.value }}
          </p>
          <p class="mt-1 text-sm text-muted">
            {{ metric.note }}
          </p>
        </div>
      </section>

      <section class="grid gap-6 xl:grid-cols-[1.35fr_0.65fr]">
        <div class="rounded-2xl border border-muted bg-elevated p-6 md:p-8">
          <div class="flex flex-col justify-between gap-3 sm:flex-row sm:items-end">
            <div>
              <p class="disqam-eyebrow">
                PERJALANAN ENAM SESI
              </p><h2 class="mt-2 text-2xl font-bold text-highlighted">
                Progress program
              </h2>
            </div>
            <NuxtLink
              to="/admin/analytics"
              class="text-sm font-semibold text-primary hover:underline"
            >Lihat analitik <span aria-hidden="true">â†’</span></NuxtLink>
          </div>
          <div class="mt-7 space-y-5">
            <div
              v-for="item in sessionProgress"
              :key="item.session"
              class="grid gap-2 sm:grid-cols-[3rem_1fr_auto] sm:items-center"
            >
              <span class="text-lg font-bold text-primary">{{ item.session }}</span>
              <div>
                <div class="flex justify-between gap-4 text-sm">
                  <span class="font-semibold text-highlighted">{{ item.title }}</span><span class="text-muted">{{ item.completed }} selesai</span>
                </div>
                <UProgress
                  :model-value="progress(item.completed)"
                  color="primary"
                  size="sm"
                  class="mt-2"
                />
              </div>
              <span class="text-sm font-semibold text-muted sm:min-w-12 sm:text-right">{{ progress(item.completed) }}%</span>
            </div>
          </div>
        </div>

        <div class="rounded-2xl border border-muted bg-accented p-6 md:p-8">
          <p class="disqam-eyebrow">
            BUKU HARIAN TIDUR
          </p>
          <h2 class="mt-2 text-2xl font-bold text-highlighted">
            Aktivitas pencatatan
          </h2>
          <p class="mt-3 text-sm leading-6 text-muted">
            {{ diarySummary.note }}
          </p>
          <div class="mt-8 grid grid-cols-2 gap-5">
            <div>
              <p class="text-3xl font-bold text-highlighted">
                {{ diarySummary.totalEntries }}
              </p><p class="mt-1 text-sm text-muted">
                total catatan
              </p>
            </div>
            <div>
              <p class="text-3xl font-bold text-highlighted">
                {{ diarySummary.lastSevenDays }}
              </p><p class="mt-1 text-sm text-muted">
                7 hari terakhir
              </p>
            </div>
          </div>
          <div class="mt-8 border-t border-muted pt-5">
            <p class="text-sm text-muted">
              Peserta aktif mencatat
            </p><p class="mt-1 text-xl font-bold text-primary">
              {{ diarySummary.activeParticipants }} peserta
            </p>
          </div>
          <UButton
            to="/admin/diary"
            variant="outline"
            color="primary"
            class="mt-6"
            trailing-icon="i-lucide-arrow-up-right"
          >
            Buka monitoring diary
          </UButton>
        </div>
      </section>

      <section class="grid gap-6 xl:grid-cols-[0.9fr_1.1fr]">
        <div class="rounded-2xl border border-muted bg-elevated p-6 md:p-8">
          <div class="flex items-end justify-between gap-3">
            <div>
              <p class="disqam-eyebrow">
                AKTIVITAS TERBARU
              </p><h2 class="mt-2 text-2xl font-bold text-highlighted">
                Apa yang baru
              </h2>
            </div><UIcon
              name="i-lucide-sparkles"
              class="size-6 text-warning"
            />
          </div>
          <div class="mt-6 divide-y divide-muted">
            <div
              v-for="activity in recentActivity"
              :key="`${activity.code}-${activity.time}`"
              class="flex gap-4 py-4 first:pt-0 last:pb-0"
            >
              <span class="mt-1 flex size-9 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-xs font-bold text-primary">{{ activity.initials.slice(0, 2) }}</span>
              <div class="min-w-0">
                <p class="text-sm leading-6 text-default">
                  <strong class="font-bold text-highlighted">{{ activity.code }}</strong> {{ activity.event }}
                </p><p class="mt-1 text-xs text-muted">
                  {{ formatActivityTime(activity.time) }}
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="night-surface rounded-2xl p-6 md:p-8">
          <p class="text-sm font-bold uppercase tracking-[0.15em] text-[#B5E5E9]">
            CATATAN UNTUK ADMIN
          </p>
          <h2 class="mt-3 text-2xl font-bold text-white">
            Baca data sebagai pola, bukan kesimpulan tunggal.
          </h2>
          <p class="mt-4 max-w-xl text-base leading-7 text-[#D8E9EE]">
            Ringkasan aktivitas membantu menentukan peserta yang perlu dipantau lebih dekat. Interpretasi klinis tetap mengikuti protokol dan pendampingan yang berlaku.
          </p>
          <div class="mt-7 flex items-center gap-3 text-sm font-semibold text-warning">
            <span class="size-2 rounded-full bg-warning" /> Materi dan catatan peserta tetap pseudonim
          </div>
        </div>
      </section>
    </template>
  </div>
</template>
