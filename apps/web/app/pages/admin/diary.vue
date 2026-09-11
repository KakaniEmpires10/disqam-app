<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })

type ApiResponse<T> = { success: boolean, data: T }
type DiaryParticipant = {
  id: string
  code: string
  initials: string
  ageAtEnrollment: number | null
  gender: string | null
  diaryCount: number
  lastDiaryAt: string | null
}
type ParticipantList = { items: DiaryParticipant[], page: number, pageSize: number, total: number }
type DiaryEntry = {
  sleepDate: string
  bedTime: string
  sleepStartTime: string | null
  nightAwakenings: number | null
  totalAwakeMinutes: number | null
  finalWakeTime: string
  outOfBedTime: string
  napMinutes: number | null
  updatedAt: string
  timeInBedMinutes: number
  sleepMinutes: number
  sleepEfficiency: number | null
  isComplete: boolean
}
type DiaryDetail = { participant: Pick<DiaryParticipant, 'code' | 'initials' | 'ageAtEnrollment' | 'gender'>, entries: DiaryEntry[] }

const page = ref(1)
const search = ref('')
const from = ref('')
const to = ref('')
const detailOpen = ref(false)
const selectedCode = ref<string | null>(null)
const detail = ref<DiaryDetail | null>(null)
const detailLoading = ref(false)
const detailError = ref<string | null>(null)

const { data: listResponse, status, error, refresh } = await useFetch<ApiResponse<ParticipantList>>('/api/admin/diary/participants', {
  query: { page, search }
})
const list = computed(() => listResponse.value?.data)
const isLoading = computed(() => status.value === 'pending')
const hasPagination = computed(() => Boolean(list.value && list.value.total > list.value.pageSize))
const detailExportUrl = computed(() => {
  const params = new URLSearchParams()
  if (selectedCode.value) params.set('code', selectedCode.value)
  if (from.value) params.set('from', from.value)
  if (to.value) params.set('to', to.value)
  return `/api/admin/export?${params.toString()}`
})

function formatDate(value: string | null) {
  if (!value) return 'Belum ada catatan'
  return new Intl.DateTimeFormat('id-ID', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
}

function formatMinutes(value: number) {
  return `${value} menit`
}

async function openDetail(code: string) {
  selectedCode.value = code
  detailOpen.value = true
  detailLoading.value = true
  detailError.value = null
  try {
    const response = await $fetch<ApiResponse<DiaryDetail>>(`/api/admin/diary/${encodeURIComponent(code)}`, {
      query: { from: from.value || undefined, to: to.value || undefined }
    })
    detail.value = response.data
  } catch {
    detail.value = null
    detailError.value = 'Catatan peserta belum dapat dimuat. Periksa koneksi lalu coba lagi.'
  } finally {
    detailLoading.value = false
  }
}

watch([from, to], () => {
  if (detailOpen.value && selectedCode.value) openDetail(selectedCode.value)
})

watch(search, () => {
  page.value = 1
})
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8">
    <header class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
      <div>
        <p class="disqam-eyebrow">
          BUKU HARIAN TIDUR
        </p>
        <h1 class="mt-2 text-3xl font-bold text-highlighted">
          Monitoring diary
        </h1>
        <p class="mt-3 max-w-2xl leading-7 text-muted">
          Pilih peserta untuk melihat catatan tidur per tanggal dan ringkasan sleep efficiency.
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
      title="Daftar peserta belum dapat dimuat"
      description="Periksa koneksi lalu coba muat ulang halaman."
    />

    <UCard v-else>
      <div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_auto_auto] md:items-end">
        <UFormField label="Cari kode peserta">
          <UInput
            v-model="search"
            icon="i-lucide-search"
            placeholder="Contoh: DQ-K72MP"
            class="w-full"
          />
        </UFormField>
        <UFormField label="Tanggal mulai detail">
          <UInput
            v-model="from"
            type="date"
          />
        </UFormField>
        <UFormField label="Tanggal akhir detail">
          <UInput
            v-model="to"
            type="date"
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
        class="space-y-3"
      >
        <USkeleton
          v-for="item in 6"
          :key="item"
          class="h-14 w-full"
        />
      </div>
      <div
        v-else-if="!list?.items.length"
        class="py-12 text-center"
      >
        <UIcon
          name="i-lucide-book-heart"
          class="mx-auto size-10 text-muted"
        />
        <p class="mt-4 text-lg font-semibold text-highlighted">
          Belum ada peserta.
        </p>
        <p class="mt-2 text-muted">
          Peserta yang terdaftar akan tampil di sini.
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
                Jumlah catatan
              </th>
              <th class="px-4 py-3 font-semibold">
                Catatan terakhir
              </th>
              <th class="px-4 py-3 text-right font-semibold">
                Aksi
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-default">
            <tr
              v-for="participant in list.items"
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
                {{ participant.diaryCount }}
              </td>
              <td class="px-4 py-4 text-muted">
                {{ formatDate(participant.lastDiaryAt) }}
              </td>
              <td class="px-4 py-4 text-right">
                <UButton
                  color="primary"
                  variant="soft"
                  size="sm"
                  icon="i-lucide-eye"
                  @click="openDetail(participant.code)"
                >
                  Lihat catatan
                </UButton>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="flex items-center justify-between border-t border-default px-4 py-4 text-sm text-muted">
          <span>Menampilkan {{ list.items.length }} dari {{ list.total }} peserta</span>
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
              :disabled="page * list.pageSize >= list.total"
              @click="page++"
            >
              Berikutnya
            </UButton>
          </div>
        </div>
      </div>
    </UCard>

    <USlideover
      v-model:open="detailOpen"
      side="right"
      inset
      :title="detail?.participant.code || selectedCode || 'Detail catatan'"
      :description="detail ? `Inisial ${detail.participant.initials} · ${detail.entries.length} catatan ditampilkan` : 'Memuat catatan tidur peserta.'"
      :ui="{ content: 'sm:max-w-5xl' }"
    >
      <template #header>
        <div class="flex items-start justify-between gap-4">
          <div>
            <p class="disqam-eyebrow">
              DETAIL PESERTA
            </p>
            <h2 class="mt-2 text-2xl font-bold text-highlighted">
              {{ detail?.participant.code || selectedCode }}
            </h2>
            <p
              v-if="detail"
              class="mt-1 text-muted"
            >
              Inisial {{ detail.participant.initials }} · {{ detail.entries.length }} catatan ditampilkan
            </p>
          </div>
          <UButton
            icon="i-lucide-x"
            color="neutral"
            variant="ghost"
            aria-label="Tutup detail"
            @click="detailOpen = false"
          />
        </div>
      </template>
      <template #body>
        <div
          v-if="detailLoading"
          class="space-y-3"
        >
          <USkeleton
            v-for="item in 4"
            :key="item"
            class="h-16 w-full"
          />
        </div>
        <UAlert
          v-else-if="detailError"
          color="error"
          variant="soft"
          :description="detailError"
        />
        <div
          v-else-if="!detail?.entries.length"
          class="py-8 text-center text-muted"
        >
          Tidak ada catatan pada rentang tanggal ini.
        </div>
        <div
          v-else
          class="overflow-x-auto"
        >
          <table class="w-full min-w-[980px] text-left text-sm">
            <thead class="border-b border-default text-muted">
              <tr>
                <th class="px-3 py-3 font-semibold">
                  Tanggal
                </th>
                <th class="px-3 py-3 font-semibold">
                  Di tempat tidur
                </th>
                <th class="px-3 py-3 font-semibold">
                  Mulai tidur
                </th>
                <th class="px-3 py-3 font-semibold">
                  Bangun terakhir
                </th>
                <th class="px-3 py-3 font-semibold">
                  Waktu di tempat tidur
                </th>
                <th class="px-3 py-3 font-semibold">
                  Sleep efficiency
                </th>
                <th class="px-3 py-3 font-semibold">
                  Kelengkapan
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-default">
              <tr
                v-for="entry in detail.entries"
                :key="entry.sleepDate"
              >
                <td class="px-3 py-4 font-semibold text-highlighted">
                  {{ entry.sleepDate }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ entry.bedTime }} – {{ entry.outOfBedTime }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ entry.sleepStartTime || '—' }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ entry.finalWakeTime }}
                </td>
                <td class="px-3 py-4 text-muted">
                  {{ formatMinutes(entry.timeInBedMinutes) }}
                </td>
                <td class="px-3 py-4 font-semibold text-primary">
                  {{ entry.sleepEfficiency === null ? 'Tidak dapat dihitung' : `${entry.sleepEfficiency}%` }}
                </td>
                <td class="px-3 py-4">
                  <UBadge
                    :color="entry.isComplete ? 'success' : 'warning'"
                    variant="soft"
                  >
                    {{ entry.isComplete ? 'Lengkap' : 'Belum lengkap' }}
                  </UBadge>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
      <template #footer>
        <UButton
          v-if="detail"
          :to="detailExportUrl"
          target="_blank"
          icon="i-lucide-download"
          color="primary"
        >
          Unduh CSV detail
        </UButton>
      </template>
    </USlideover>
  </div>
</template>
