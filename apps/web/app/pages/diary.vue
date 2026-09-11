<!-- Participant diary access is established only by an opaque link generated in the mobile app. -->
<script setup lang="ts">
/* eslint-disable @typescript-eslint/no-explicit-any */
type Profile = { code: string, initials: string }

const route = useRoute()
const profile = ref<Profile | null>(null)
const loading = ref(true)
const saving = ref(false)
const message = ref('')
const error = ref('')
const form = reactive({ sleepDate: new Date().toISOString().slice(0, 10), bedTime: '21:30', sleepStartTime: '22:00', nightAwakenings: 0, totalAwakeMinutes: 0, finalWakeTime: '05:30', outOfBedTime: '06:00', napMinutes: 0 })

async function loadSession() {
  try {
    const response = await $fetch<{ success: boolean, data: { participant: Profile } }>('/api/participant/me')
    profile.value = response.data.participant
  } catch {
    profile.value = null
  } finally {
    loading.value = false
  }
}

async function save() {
  error.value = ''
  message.value = ''
  saving.value = true
  try {
    await $fetch('/api/participant/diary', { method: 'POST', body: form })
    message.value = 'Catatan tidur berhasil disimpan.'
  } catch (e: any) {
    error.value = e?.data?.message || 'Catatan belum berhasil disimpan. Periksa koneksi lalu coba lagi.'
  } finally {
    saving.value = false
  }
}

onMounted(async () => {
  const token = route.query.access
  if (typeof token === 'string' && token.length > 0) {
    window.location.replace(`/api/participant/diary-link?token=${encodeURIComponent(token)}`)
    return
  }
  await loadSession()
  if (!profile.value) await navigateTo('/')
})
</script>

<template>
  <div class="page-frame diary-page">
    <div class="mx-auto max-w-6xl px-5 pt-8 md:px-10 md:pt-12">
      <header class="flex items-center justify-between">
        <div class="flex items-center gap-3">
          <img
            src="/mark.webp"
            alt=""
            class="size-10 object-contain"
          >
          <span class="text-lg font-extrabold tracking-[0.16em] text-highlighted">DISQAM</span>
        </div>
        <UColorModeButton aria-label="Ubah tema warna" />
      </header>
      <section class="night-surface mt-10 rounded-[24px] p-7 md:p-10">
        <p class="relative z-10 text-sm font-bold uppercase tracking-[0.15em] text-[#B5E5E9]">
          BUKU HARIAN TIDUR
        </p>
        <h1 class="relative z-10 mt-3 text-3xl font-bold text-white md:text-5xl">
          Satu pagi, satu catatan.
        </h1>
        <p class="relative z-10 mt-4 max-w-2xl text-base leading-7 text-[#D8E9EE]">
          Catat satu malam setiap pagi untuk melihat pola tidur dari waktu ke waktu.
        </p>
      </section>
    </div>

    <UContainer class="pb-16">
      <UAlert
        v-if="message"
        color="success"
        variant="subtle"
        :description="message"
        class="mb-6"
      />
      <UAlert
        v-if="error"
        color="error"
        variant="subtle"
        :description="error"
        class="mb-6"
      />
      <div
        v-if="loading"
        class="flex justify-center py-16"
      >
        <USkeleton class="h-32 w-full max-w-2xl" />
      </div>
      <div
        v-else-if="profile"
        class="mx-auto max-w-3xl space-y-8"
      >
        <div class="soft-tile rounded-2xl p-6">
          <p class="disqam-eyebrow">
            PESERTA {{ profile.code }}
          </p>
          <h2 class="mt-2 text-2xl font-bold text-highlighted">
            Catatan malam ini
          </h2>
          <p class="mt-2 text-muted">
            Inisial {{ profile.initials }}
          </p>
        </div>

        <UCard
          class="diary-form-card"
          :ui="{ body: 'p-6 md:p-8' }"
        >
          <form
            class="diary-form grid gap-6 sm:grid-cols-2"
            @submit.prevent="save"
          >
            <div class="sm:col-span-2 diary-section-heading">
              <p class="disqam-eyebrow">
                MALAM YANG DICATAT
              </p>
              <p class="mt-1 text-sm text-muted">
                Gunakan waktu yang paling mendekati pengalaman semalam.
              </p>
            </div>
            <UFormField
              label="Tanggal catatan"
              required
            >
              <UInput
                v-model="form.sleepDate"
                type="date"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <div class="hidden sm:block" />
            <UFormField
              label="Jam masuk tempat tidur"
              required
            >
              <UInput
                v-model="form.bedTime"
                type="time"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <UFormField label="Jam mulai tidur">
              <UInput
                v-model="form.sleepStartTime"
                type="time"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <div class="sm:col-span-2 diary-section-heading border-t border-muted pt-6">
              <p class="disqam-eyebrow">
                TERJAGA DI MALAM HARI
              </p>
              <p class="mt-1 text-sm text-muted">
                Isi perkiraan total bila tidak mengingat angka pastinya.
              </p>
            </div>
            <UFormField label="Berapa kali terbangun malam">
              <UInput
                v-model.number="form.nightAwakenings"
                type="number"
                min="0"
                max="100"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <UFormField label="Total lama terjaga (menit)">
              <UInput
                v-model.number="form.totalAwakeMinutes"
                type="number"
                min="0"
                max="1440"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <div class="sm:col-span-2 diary-section-heading border-t border-muted pt-6">
              <p class="disqam-eyebrow">
                PAGI DAN TIDUR SIANG
              </p>
            </div>
            <UFormField
              label="Jam bangun terakhir"
              required
            >
              <UInput
                v-model="form.finalWakeTime"
                type="time"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <UFormField
              label="Jam keluar dari tempat tidur"
              required
            >
              <UInput
                v-model="form.outOfBedTime"
                type="time"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <UFormField label="Durasi tidur siang (menit)">
              <UInput
                v-model.number="form.napMinutes"
                type="number"
                min="0"
                max="1440"
                class="diary-control w-full"
                size="xl"
              />
            </UFormField>
            <div class="sm:col-span-2 flex justify-end border-t border-muted pt-6">
              <UButton
                type="submit"
                size="xl"
                :loading="saving"
                icon="i-lucide-save"
              >
                Simpan catatan
              </UButton>
            </div>
          </form>
        </UCard>
      </div>
    </UContainer>
  </div>
</template>
