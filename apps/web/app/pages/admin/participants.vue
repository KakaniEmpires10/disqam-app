<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

const page = ref(1)

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
  query: { page }
})
const data = computed(() => response.value?.data)
const isLoading = computed(() => status.value === 'pending')

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
      title="Data peserta belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />

    <UCard
      v-else
      class="overflow-hidden"
    >
      <div
        v-if="isLoading"
        class="space-y-3"
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
          <div class="flex gap-2">
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
