<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type ApiResponse<T> = { success: boolean, data: T }
type DashboardResponse = {
  sessionProgress: Array<{ session: string, title: string, completed: number, opened: number, total: number }>
}
type DiaryAnalytics = {
  summary: {
    totalEntries: number
    completeEntries: number
    participantsWithDiary: number
    averageSleepEfficiency: number | null
    completenessRate: number | null
  }
  participants: Array<{
    code: string
    initials: string
    diaryCount: number
    completenessRate: number | null
    averageSleepEfficiency: number | null
    averageSleepMinutes: number | null
    lastDiaryAt: string | null
  }>
  note: string
}

const { data: dashboardResponse, status: dashboardStatus, error: dashboardError, refresh: refreshDashboard } = await useFetch<ApiResponse<DashboardResponse>>('/api/admin/dashboard')
const { data: diaryResponse, status: diaryStatus, error: diaryError, refresh: refreshDiary } = await useFetch<ApiResponse<DiaryAnalytics>>('/api/admin/analytics')
const dashboard = computed(() => dashboardResponse.value?.data)
const analytics = computed(() => diaryResponse.value?.data)
const isLoading = computed(() => dashboardStatus.value === 'pending' || diaryStatus.value === 'pending')
const error = computed(() => dashboardError.value || diaryError.value)

const metrics = computed(() => [
  { label: 'Total catatan', value: String(analytics.value?.summary.totalEntries ?? 0), note: 'catatan tidur tersimpan', icon: 'i-lucide-book-heart' },
  { label: 'Peserta mencatat', value: String(analytics.value?.summary.participantsWithDiary ?? 0), note: 'minimal satu catatan', icon: 'i-lucide-users-round' },
  { label: 'Efisiensi rata-rata', value: analytics.value?.summary.averageSleepEfficiency == null ? '—' : `${analytics.value.summary.averageSleepEfficiency}%`, note: 'dari data yang dapat dihitung', icon: 'i-lucide-activity' },
  { label: 'Data lengkap', value: analytics.value?.summary.completenessRate == null ? '—' : `${analytics.value.summary.completenessRate}%`, note: 'catatan dengan isian lengkap', icon: 'i-lucide-clipboard-check' }
])

async function refresh() {
  await Promise.all([refreshDashboard(), refreshDiary()])
}

function formatDate(value: string | null) {
  if (!value) return 'Belum ada catatan'
  return new Intl.DateTimeFormat('id-ID', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
}

function formatMinutes(value: number | null) {
  return value === null ? '—' : `${value} menit`
}
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          ANALITIK
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Ringkasan analitik
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Ringkasan pola pencatatan tidur dan perkembangan program peserta.
        </p>
      </div>
      <UButton
        icon="i-lucide-refresh-cw"
        color="neutral"
        variant="outline"
        :loading="isLoading"
        @click="refresh"
      >
        Muat ulang
      </UButton>
    </header>

    <UAlert
      v-if="error"
      color="error"
      variant="soft"
      title="Analitik belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />

    <template v-else>
      <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <UCard
          v-for="metric in metrics"
          :key="metric.label"
        >
          <div
            v-if="isLoading"
            class="space-y-3"
          >
            <USkeleton class="h-5 w-36" />
            <USkeleton class="h-9 w-24" />
            <USkeleton class="h-4 w-44" />
          </div>
          <template v-else>
            <div class="flex items-start justify-between gap-3">
              <p class="text-sm font-medium text-muted">
                {{ metric.label }}
              </p>
              <span class="flex size-10 items-center justify-center rounded-xl bg-primary/10 text-primary"><UIcon
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
          </template>
        </UCard>
      </section>

      <UCard>
        <template #header>
          <p class="disqam-eyebrow">
            PERJALANAN PROGRAM
          </p>
          <h2 class="mt-2 text-2xl font-bold text-highlighted">
            Progress enam sesi
          </h2>
        </template>
        <div
          v-if="isLoading"
          class="space-y-4"
        >
          <USkeleton
            v-for="item in 6"
            :key="item"
            class="h-12 w-full"
          />
        </div>
        <div
          v-else
          class="space-y-5"
        >
          <div
            v-for="item in dashboard?.sessionProgress"
            :key="item.session"
            class="grid gap-2 sm:grid-cols-[3rem_1fr_auto] sm:items-center"
          >
            <span class="text-lg font-bold text-primary">{{ item.session }}</span>
            <div>
              <div class="flex justify-between gap-4 text-sm">
                <span class="font-semibold text-highlighted">{{ item.title }}</span><span class="text-muted">{{ item.completed }} selesai</span>
              </div>
              <UProgress
                :model-value="item.total ? Math.round(item.completed / item.total * 100) : 0"
                color="primary"
                size="sm"
                class="mt-2"
              />
            </div>
            <span class="text-sm font-semibold text-muted sm:min-w-12 sm:text-right">{{ item.total ? Math.round(item.completed / item.total * 100) : 0 }}%</span>
          </div>
        </div>
      </UCard>

      <UCard>
        <template #header>
          <p class="disqam-eyebrow">
            EFISIENSI PER PESERTA
          </p>
          <h2 class="mt-2 text-2xl font-bold text-highlighted">
            Ringkasan buku harian tidur
          </h2>
          <p class="mt-2 text-muted">
            {{ analytics?.note }}
          </p>
        </template>
        <div
          v-if="isLoading"
          class="space-y-3"
        >
          <USkeleton
            v-for="item in 6"
            :key="item"
            class="h-14 w-full"
          />
        </div>
        <div
          v-else-if="!analytics?.participants.length"
          class="py-10 text-center text-muted"
        >
          Belum ada data buku harian tidur.
        </div>
        <div
          v-else
          class="overflow-x-auto"
        >
          <table class="w-full min-w-[900px] text-left text-sm">
            <thead class="border-b border-default text-muted">
              <tr>
                <th class="px-3 py-3 font-semibold">
                  Peserta
                </th>
                <th class="px-3 py-3 font-semibold">
                  Catatan
                </th>
                <th class="px-3 py-3 font-semibold">
                  Kelengkapan
                </th>
                <th class="px-3 py-3 font-semibold">
                  Efisiensi rata-rata
                </th>
                <th class="px-3 py-3 font-semibold">
                  Tidur rata-rata
                </th>
                <th class="px-3 py-3 font-semibold">
                  Catatan terakhir
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-default">
              <tr
                v-for="participant in analytics.participants"
                :key="participant.code"
                class="hover:bg-muted/50"
              >
                <td class="px-3 py-4">
                  <p class="font-semibold text-highlighted">
                    {{ participant.code }}
                  </p><p class="mt-1 text-muted">
                    {{ participant.initials }}
                  </p>
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ participant.diaryCount }}
                </td>
                <td class="px-3 py-4">
                  <UBadge
                    :color="participant.completenessRate === 100 ? 'success' : 'warning'"
                    variant="soft"
                  >
                    {{ participant.completenessRate === null ? '—' : `${participant.completenessRate}%` }}
                  </UBadge>
                </td>
                <td class="px-3 py-4 font-semibold text-primary">
                  {{ participant.averageSleepEfficiency === null ? '—' : `${participant.averageSleepEfficiency}%` }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ formatMinutes(participant.averageSleepMinutes) }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ formatDate(participant.lastDiaryAt) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </UCard>
    </template>
  </div>
</template>
