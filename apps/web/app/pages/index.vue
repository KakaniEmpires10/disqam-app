<script setup lang="ts">
const auth = useAdminAuth()
const route = useRoute()
const email = ref('')
const password = ref('')
const passwordVisible = ref(false)
const pending = ref(false)
const error = ref('')

definePageMeta({
  layout: false,
  middleware: 'guest-admin'
})

function redirectPath() {
  const value = route.query.redirect
  return typeof value === 'string' && value.startsWith('/admin') && value !== '/admin/login' ? value : '/admin'
}

async function submit() {
  error.value = ''
  if (!email.value.trim() || !password.value) {
    error.value = 'Masukkan email dan kata sandi admin.'
    return
  }
  pending.value = true
  try {
    await auth.login(email.value, password.value)
    await navigateTo(redirectPath())
  } catch {
    error.value = auth.error.value || 'Login belum berhasil. Periksa koneksi lalu coba lagi.'
  } finally {
    pending.value = false
  }
}
</script>

<template>
  <main class="page-frame grid min-h-screen gap-6 p-2 md:gap-8 md:p-2 lg:grid-cols-[minmax(0,1.3fr)_minmax(24rem,0.7fr)] lg:gap-10 lg:p-4">
    <section class="night-surface relative flex min-h-[22rem] flex-col justify-between rounded-2xl p-8 md:p-12 lg:min-h-[calc(100vh-2.5rem)] lg:p-16">
      <div class="relative z-10 flex items-center gap-3">
        <img
          src="/mark.webp"
          alt=""
          class="size-12 object-contain"
        >
        <span class="text-xl font-extrabold tracking-[0.16em] text-white">DISQAM</span>
      </div>
      <div class="relative z-10 max-w-xl py-12">
        <p class="text-sm font-bold uppercase tracking-[0.16em] text-[#B5E5E9]">
          RUANG MONITORING
        </p>
        <h1 class="mt-5 text-4xl font-bold leading-tight text-white md:text-6xl">
          Melihat perjalanan peserta dengan lebih tenang.
        </h1>
        <p class="mt-6 max-w-lg text-lg leading-8 text-[#D8E9EE]">
          Akses admin untuk membaca perkembangan program, aktivitas sleep diary, dan ringkasan peserta secara pseudonim.
        </p>
      </div>
      <p class="relative z-10 text-sm text-[#B5E5E9]">
        DISQAM · Digital Improving Sleep Quality for Aging Management
      </p>
    </section>

    <section class="relative flex items-center justify-center px-5 py-12 md:px-10 lg:px-16">
      <div class="absolute right-5 top-5 md:right-8 md:top-8">
        <UColorModeButton aria-label="Ubah tema warna" />
      </div>
      <div class="w-full max-w-sm">
        <div class="mb-8 lg:hidden">
          <img
            src="/mark.webp"
            alt="DISQAM"
            class="size-14 object-contain"
          >
        </div>
        <p class="disqam-eyebrow">
          ADMIN
        </p>
        <h2 class="mt-3 text-3xl font-bold text-highlighted">
          Masuk ke monitoring
        </h2>
        <p class="mt-3 text-base leading-7 text-muted">
          Gunakan akun admin yang telah disiapkan untuk proyek DISQAM.
        </p>
        <UAlert
          v-if="error"
          class="mt-6"
          color="error"
          variant="subtle"
          icon="i-lucide-circle-alert"
          :description="error"
        />
        <form
          class="mt-8 space-y-5"
          @submit.prevent="submit"
        >
          <UFormField
            label="Email admin"
            name="email"
            required
          >
            <UInput
              v-model="email"
              type="email"
              autocomplete="username"
              placeholder="admin@contoh.id"
              class="w-full"
              size="xl"
            />
          </UFormField>
          <UFormField
            label="Kata sandi"
            name="password"
            required
          >
            <UInput
              v-model="password"
              :type="passwordVisible ? 'text' : 'password'"
              autocomplete="current-password"
              placeholder="Masukkan kata sandi"
              class="w-full"
              size="xl"
            >
              <template #trailing>
                <UButton
                  type="button"
                  color="neutral"
                  variant="ghost"
                  size="sm"
                  square
                  :icon="passwordVisible ? 'i-lucide-eye-off' : 'i-lucide-eye'"
                  :aria-label="passwordVisible ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi'"
                  @click="passwordVisible = !passwordVisible"
                />
              </template>
            </UInput>
          </UFormField>
          <UButton
            type="submit"
            block
            size="xl"
            :loading="pending"
            icon="i-lucide-arrow-right"
          >
            Masuk ke monitoring
          </UButton>
        </form>
        <div class="mt-8 border-l-2 border-primary bg-primary/10 px-4 py-3 text-sm leading-6 text-default">
          Akses ini hanya untuk admin. Data peserta ditampilkan secara terbatas sesuai kebutuhan monitoring.
        </div>
      </div>
    </section>
  </main>
</template>
