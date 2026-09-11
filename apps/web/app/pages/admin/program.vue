<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type ProgramResponse = {
  summary: { totalParticipants: number }
  sessionProgress: Array<{ session: string, title: string, opened: number, completed: number, total: number }>
}

type ApiResponse<T> = { success: boolean, data: T }

const { data: response, status, error, refresh } = await useFetch<ApiResponse<ProgramResponse>>('/api/admin/dashboard')
const data = computed(() => response.value?.data)
const isLoading = computed(() => status.value === 'pending')
function percentage(value: number) {
  const total = data.value?.summary.totalParticipants ?? 0
  return total ? Math.round((value / total) * 100) : 0
}
</script>

<template>
  <div class="mx-auto max-w-6xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          PROGRAM DISQAM
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Progress program
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Pantau pembukaan dan penyelesaian enam sesi program dari data peserta.
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
      title="Progress belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />
    <UCard v-else>
      <div
        v-if="isLoading"
        class="space-y-5"
      >
        <USkeleton
          v-for="item in 6"
          :key="item"
          class="h-16 w-full"
        />
      </div>
      <div
        v-else-if="!data?.sessionProgress.length"
        class="py-12 text-center text-muted"
      >
        Belum ada data progress program.
      </div>
      <div
        v-else
        class="space-y-6"
      >
        <div
          v-for="item in data.sessionProgress"
          :key="item.session"
          class="grid gap-3 sm:grid-cols-[3rem_1fr_auto] sm:items-center"
        >
          <span class="text-lg font-bold text-primary">{{ item.session }}</span>
          <div>
            <div class="flex flex-wrap justify-between gap-2">
              <span class="font-semibold text-highlighted">{{ item.title }}</span>
              <span class="text-sm text-muted">{{ item.completed }} selesai · {{ item.opened }} dibuka</span>
            </div>
            <UProgress
              :model-value="percentage(item.completed)"
              color="primary"
              class="mt-2"
            />
          </div>
          <span class="text-sm font-semibold text-muted">{{ percentage(item.completed) }}%</span>
        </div>
      </div>
    </UCard>
  </div>
</template>
