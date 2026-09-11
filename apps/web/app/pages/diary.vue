<!-- Participant diary access is established only by an opaque link generated in the mobile app. -->
<script setup lang="ts">
/* eslint-disable @typescript-eslint/no-explicit-any */
type Profile = { code: string, initials: string }

const route = useRoute()
const profile = ref<Profile | null>(null)
const loading = ref(true)
const saving = ref(false)
const toast = useToast()
const form = reactive({ sleepDate: new Date().toISOString().slice(0, 10), bedTime: '21:30', sleepStartTime: '22:00', nightAwakenings: 0, totalAwakeMinutes: 0, finalWakeTime: '05:30', outOfBedTime: '06:00', napMinutes: 0 })

useSeoMeta({
  title: 'Buku Harian Tidur · DISQAM',
  description: 'Catat dan perbarui waktu tidur Anda setiap hari bersama DISQAM.'
})

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
  saving.value = true
  try {
    await $fetch('/api/participant/diary', { method: 'POST', body: form })
    toast.add({
      title: 'Catatan tersimpan',
      description: 'Catatan tidur berhasil disimpan.',
      color: 'success',
      icon: 'i-lucide-circle-check'
    })
  } catch (e: any) {
    toast.add({
      title: 'Catatan belum tersimpan',
      description: e?.data?.message || 'Periksa koneksi lalu coba lagi.',
      color: 'error',
      icon: 'i-lucide-circle-alert'
    })
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

    <UContainer class="pt-12 pb-16">
      <div
        v-if="loading"
        class="mx-auto max-w-3xl"
      >
        <UCard :ui="{ body: 'p-6 md:p-8', header: 'p-6 md:p-8' }">
          <template #header>
            <div class="flex items-center justify-between gap-4">
              <div class="space-y-3">
                <USkeleton class="h-3 w-36" />
                <USkeleton class="h-7 w-56" />
                <USkeleton class="h-4 w-72 max-w-full" />
              </div>
              <USkeleton class="h-20 w-28" />
            </div>
          </template>
          <div class="grid gap-6 sm:grid-cols-2">
            <div class="sm:col-span-2 space-y-3">
              <USkeleton class="h-3 w-36" />
              <USkeleton class="h-4 w-80 max-w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-36" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="hidden sm:block" />
            <div class="space-y-3">
              <USkeleton class="h-4 w-48" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-36" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="sm:col-span-2 space-y-3 border-t border-muted pt-6">
              <USkeleton class="h-3 w-44" />
              <USkeleton class="h-4 w-80 max-w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-52" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-56" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="sm:col-span-2 space-y-3 border-t border-muted pt-6">
              <USkeleton class="h-3 w-48" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-44" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-52" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="space-y-3">
              <USkeleton class="h-4 w-48" />
              <USkeleton class="h-14 w-full" />
            </div>
            <div class="sm:col-span-2 flex justify-end border-t border-muted pt-6">
              <USkeleton class="h-14 w-44" />
            </div>
          </div>
        </UCard>
      </div>
      <div
        v-else-if="profile"
        class="mx-auto max-w-3xl space-y-8"
      >
        <UCard
          :ui="{ body: 'p-6 md:p-8', header: 'p-6 md:p-8' }"
        >
          <template #header>
            <div class="grid gap-6 md:grid-cols-[minmax(0,1fr)_auto] md:items-center">
              <div>
                <p class="disqam-eyebrow">
                  BUKU HARIAN TIDUR
                </p>

                <h2 class="mt-2 text-2xl font-bold text-highlighted">
                  Catatan malam ini
                </h2>

                <p class="mt-2 max-w-xl text-sm leading-6 text-muted">
                  Catatan pada tanggal yang sama otomatis menimpa catatan sebelumnya.
                  Isi kembali bagian yang ingin diubah jika ada data yang salah atau kurang
                  sesuai, lalu tekan Simpan catatan.
                </p>
              </div>

              <div class="rounded-lg bg-muted px-3 py-2 text-right">
                <p class="text-xs font-semibold uppercase tracking-wide text-muted">
                  Peserta
                </p>
                <p class="mt-1 font-bold text-highlighted">
                  {{ profile.code }}
                </p>
                <p class="text-sm text-muted">
                  Inisial {{ profile.initials }}
                </p>
              </div>
            </div>
          </template>
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
              />
            </UFormField>
            <UFormField label="Jam mulai tidur">
              <UInput
                v-model="form.sleepStartTime"
                type="time"
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
              />
            </UFormField>
            <UFormField label="Total lama terjaga (menit)">
              <UInput
                v-model.number="form.totalAwakeMinutes"
                type="number"
                min="0"
                max="1440"
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
              />
            </UFormField>
            <UFormField
              label="Jam keluar dari tempat tidur"
              required
            >
              <UInput
                v-model="form.outOfBedTime"
                type="time"
              />
            </UFormField>
            <UFormField label="Durasi tidur siang (menit)">
              <UInput
                v-model.number="form.napMinutes"
                type="number"
                min="0"
                max="1440"
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
      <UCard
        v-else
        class="mx-auto max-w-3xl"
        :ui="{ body: 'p-6 md:p-8' }"
      >
        <UAlert
          color="info"
          variant="subtle"
          icon="i-lucide-link"
          title="Buku harian belum terbuka"
          :description="route.query.accessError === '1'
            ? 'Tautan dari aplikasi sudah tidak dapat digunakan. Silakan minta tautan baru dari aplikasi DISQAM.'
            : 'Untuk mengisi buku harian, silakan buka tautan yang dikirim dari aplikasi DISQAM.'"
        />
      </UCard>
    </UContainer>
  </div>
</template>
