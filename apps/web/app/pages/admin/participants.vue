<script setup lang="ts">
import { refDebounced } from '@vueuse/core'

definePageMeta({
  middleware: 'admin',
  layout: 'admin-shell',
  title: 'Daftar Peserta',
  description: 'Daftar peserta pseudonim dan aktivitas program DISQAM.'
})

const page = ref(1)
const search = ref('')
const debouncedSearch = refDebounced(search, 350)
const gender = ref('all')
const progress = ref('all')

const genderOptions = [
  { label: 'Semua jenis kelamin', value: 'all' },
  { label: 'Laki-laki', value: 'male' },
  { label: 'Perempuan', value: 'female' },
  { label: 'Tidak diisi', value: 'unspecified' }
]
const progressOptions = [
  { label: 'Semua progress', value: 'all' },
  { label: 'Belum mulai', value: 'not-started' },
  { label: 'Sedang berjalan', value: 'in-progress' },
  { label: 'Selesai', value: 'completed' }
]

type ParticipantRow = {
  id: string
  code: string
  initials: string
  ageAtEnrollment: number | null
  gender: string | null
  createdAt: string
  openedSessions: number
  completedSessions: number
  lastLearningActivityAt: string | null
}

type ParticipantsResponse = {
  items: ParticipantRow[]
  page: number
  pageSize: number
  total: number
}

type ApiResponse<T> = { success: boolean, data: T }

const { data: response, status, error, refresh } = await useFetch<ApiResponse<ParticipantsResponse>>('/api/admin/participants', {
  query: { page, search: debouncedSearch, gender, progress }
})
const data = computed(() => response.value?.data)
const isLoading = computed(() => status.value === 'pending')
const hasPagination = computed(() => Boolean(data.value && data.value.total > data.value.pageSize))
const participantExportQuery = computed(() => ({
  search: debouncedSearch.value || undefined,
  gender: gender.value === 'all' ? undefined : gender.value,
  progress: progress.value === 'all' ? undefined : progress.value
}))

watch([debouncedSearch, gender, progress], () => {
  page.value = 1
})

function formatDate(value: string | null) {
  if (!value) return 'Belum ada aktivitas'
  return new Intl.DateTimeFormat('id-ID', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
}

function genderLabel(value: string | null) {
  return { male: 'Laki-laki', female: 'Perempuan', unspecified: 'Tidak diisi' }[value || ''] || 'Tidak diisi'
}
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          PESERTA
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Daftar peserta
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Data pseudonim peserta dan aktivitas belajar yang tersimpan di database.
        </p>
      </div>
      <div class="flex flex-wrap gap-3">
        <AdminExportButtons
          dataset="participants"
          :query="participantExportQuery"
        />
        <UButton
          icon="i-lucide-refresh-cw"
          color="neutral"
          variant="outline"
          :loading="isLoading"
          @click="refresh()"
        >
          Muat ulang
        </UButton>
      </div>
    </header>

    <UAlert
      v-if="error"
      color="error"
      variant="soft"
      title="Data peserta belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />

    <UCard
      v-else
    >
      <div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_minmax(12rem,0.35fr)_minmax(12rem,0.35fr)]">
        <UFormField label="Cari peserta">
          <UInput
            v-model="search"
            icon="i-lucide-search"
            placeholder="Cari kode atau inisial"
          />
        </UFormField>
        <UFormField label="Jenis kelamin">
          <USelect
            v-model="gender"
            :items="genderOptions"
            value-key="value"
          />
        </UFormField>
        <UFormField label="Progress program">
          <USelect
            v-model="progress"
            :items="progressOptions"
            value-key="value"
          />
        </UFormField>
      </div>
    </UCard>

    <UCard
      v-if="!error"
      class="overflow-hidden"
    >
      <div
        v-if="isLoading"
        class="space-y-3 p-4"
      >
        <USkeleton
          v-for="item in 6"
          :key="item"
          class="h-12 w-full"
        />
      </div>
      <div
        v-else-if="!data?.items.length"
        class="py-12 text-center"
      >
        <UIcon
          name="i-lucide-users-round"
          class="mx-auto size-10 text-muted"
        />
        <p class="mt-4 text-lg font-semibold text-highlighted">
          Belum ada peserta.
        </p>
        <p class="mt-2 text-muted">
          Peserta yang mendaftar akan tampil di sini.
        </p>
      </div>
      <div
        v-else
        class="overflow-x-auto"
      >
        <table class="w-full min-w-[760px] text-left text-sm">
          <thead class="border-b border-default text-muted">
            <tr>
              <th class="px-4 py-3 font-semibold">
                Kode
              </th>
              <th class="px-4 py-3 font-semibold">
                Inisial
              </th>
              <th class="px-4 py-3 font-semibold">
                Usia
              </th>
              <th class="px-4 py-3 font-semibold">
                Jenis kelamin
              </th>
              <th class="px-4 py-3 font-semibold">
                Progress
              </th>
              <th class="px-4 py-3 font-semibold">
                Aktivitas terakhir
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-default">
            <tr
              v-for="participant in data.items"
              :key="participant.id"
              class="hover:bg-muted/50"
            >
              <td class="px-4 py-4 font-semibold text-highlighted">
                {{ participant.code }}
              </td>
              <td class="px-4 py-4 text-default">
                {{ participant.initials }}
              </td>
              <td class="px-4 py-4 text-muted">
                {{ participant.ageAtEnrollment ?? '—' }}
              </td>
              <td class="px-4 py-4 text-muted">
                {{ genderLabel(participant.gender) }}
              </td>
              <td class="px-4 py-4">
                <UBadge
                  color="primary"
                  variant="soft"
                >
                  {{ participant.completedSessions }}/6 selesai
                </UBadge>
              </td>
              <td class="px-4 py-4 text-muted">
                {{ formatDate(participant.lastLearningActivityAt) }}
              </td>
            </tr>
          </tbody>
        </table>
        <div class="flex items-center justify-between border-t border-default px-4 py-4 text-sm text-muted">
          <span>Menampilkan {{ data.items.length }} dari {{ data.total }} peserta</span>
          <div
            v-if="hasPagination"
            class="flex gap-2"
          >
            <UButton
              color="neutral"
              variant="outline"
              :disabled="page <= 1"
              @click="page--"
            >
              Sebelumnya
            </UButton>
            <UButton
              color="neutral"
              variant="outline"
              :disabled="page * data.pageSize >= data.total"
              @click="page++"
            >
              Berikutnya
            </UButton>
          </div>
        </div>
      </div>
    </UCard>
  </div>
</template>
