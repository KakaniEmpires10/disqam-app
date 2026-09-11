<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type DiaryResponse = {
  diarySummary: { totalEntries: number, lastSevenDays: number, activeParticipants: number, note: string }
}

type ApiResponse<T> = { success: boolean, data: T }

const { data: response, status, error, refresh } = await useFetch<ApiResponse<DiaryResponse>>('/api/admin/dashboard')
const data = computed(() => response.value?.data)
const isLoading = computed(() => status.value === 'pending')
</script>

<template>
  <div class="mx-auto max-w-6xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          BUKU HARIAN TIDUR
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Monitoring diary
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Ringkasan aktivitas pencatatan tidur peserta secara deskriptif.
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
      title="Data diary belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />
    <div
      v-else
      class="grid gap-4 sm:grid-cols-3"
    >
      <UCard
        v-for="metric in [
          { label: 'Total catatan', value: data?.diarySummary.totalEntries ?? 0, note: 'semua tanggal' },
          { label: '7 hari terakhir', value: data?.diarySummary.lastSevenDays ?? 0, note: 'catatan terbaru' },
          { label: 'Peserta aktif', value: data?.diarySummary.activeParticipants ?? 0, note: 'mencatat 14 hari terakhir' }
        ]"
        :key="metric.label"
      >
        <p class="text-sm font-semibold text-muted">
          {{ metric.label }}
        </p>
        <USkeleton
          v-if="isLoading"
          class="mt-4 h-10 w-24"
        />
        <p
          v-else
          class="mt-4 text-3xl font-bold text-highlighted"
        >
          {{ metric.value }}
        </p>
        <p class="mt-1 text-sm text-muted">
          {{ metric.note }}
        </p>
      </UCard>
    </div>
    <UCard v-if="!isLoading && !error">
      <div class="flex items-center gap-3">
        <UIcon
          name="i-lucide-info"
          class="size-5 text-primary"
        />
        <p class="text-muted">
          {{ data?.diarySummary.note }}
        </p>
      </div>
    </UCard>
  </div>
</template>
