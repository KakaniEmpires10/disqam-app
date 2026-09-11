<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type AnalyticsResponse = {
  summary: { totalParticipants: number, activeParticipants: number, startedLearning: number, completedLearning: number }
  diarySummary: { totalEntries: number, lastSevenDays: number, activeParticipants: number }
}

type ApiResponse<T> = { success: boolean, data: T }

const { data: response, status, error, refresh } = await useFetch<ApiResponse<AnalyticsResponse>>('/api/admin/dashboard')
const data = computed(() => response.value?.data)
const isLoading = computed(() => status.value === 'pending')
</script>

<template>
  <div class="mx-auto max-w-6xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          ANALITIK
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Ringkasan analitik
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Metrik monitoring dari peserta, progress program, dan buku harian tidur.
        </p>
      </div>
      <UButton
        icon="i-lucide-refresh-cw"
        color="neutral"
        variant="outline"
        :loading="isLoading"
        @click="refresh()"
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
    <div
      v-else
      class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"
    >
      <UCard
        v-for="metric in [
          { label: 'Total peserta', value: data?.summary.totalParticipants ?? 0 },
          { label: 'Peserta aktif', value: data?.summary.activeParticipants ?? 0 },
          { label: 'Mulai program', value: data?.summary.startedLearning ?? 0 },
          { label: 'Program selesai', value: data?.summary.completedLearning ?? 0 }
        ]"
        :key="metric.label"
      >
        <p class="text-sm font-semibold text-muted">
          {{ metric.label }}
        </p>
        <USkeleton
          v-if="isLoading"
          class="mt-4 h-10 w-20"
        />
        <p
          v-else
          class="mt-4 text-3xl font-bold text-highlighted"
        >
          {{ metric.value }}
        </p>
      </UCard>
    </div>
    <UCard v-if="!isLoading && !error">
      <div class="flex items-center justify-between gap-4">
        <div>
          <p class="text-lg font-semibold text-highlighted">
            Aktivitas buku harian
          </p>
          <p class="mt-1 text-muted">
            {{ data?.diarySummary.totalEntries ?? 0 }} catatan tersimpan; {{ data?.diarySummary.lastSevenDays ?? 0 }} dalam 7 hari terakhir.
          </p>
        </div>
        <UBadge
          color="primary"
          variant="soft"
        >
          {{ data?.diarySummary.activeParticipants ?? 0 }} peserta aktif
        </UBadge>
      </div>
    </UCard>
  </div>
</template>
