<script setup lang="ts">
import type { NavigationMenuItem } from '@nuxt/ui'

const auth = useAdminAuth()
const sidebarOpen = ref(true)
const pendingLogout = ref(false)

const mainItems: NavigationMenuItem[] = [
  { label: 'Dashboard', icon: 'i-lucide-layout-dashboard', to: '/admin' },
  { label: 'Peserta', icon: 'i-lucide-users-round', to: '/admin/participants' },
  { label: 'Progress Program', icon: 'i-lucide-route', to: '/admin/program' },
  { label: 'Buku Harian Tidur', icon: 'i-lucide-book-heart', to: '/admin/diary' }
]
const dataItems: NavigationMenuItem[] = [
  { label: 'Analitik', icon: 'i-lucide-chart-no-axes-combined', to: '/admin/analytics' },
  { label: 'Ekspor Data', icon: 'i-lucide-download', to: '/admin/export' }
]

async function logout() {
  pendingLogout.value = true
  try {
    await auth.logout()
    await navigateTo('/')
  } finally {
    pendingLogout.value = false
  }
}
</script>

<template>
  <div class="page-frame flex min-h-screen">
    <USidebar
      v-model:open="sidebarOpen"
      variant="inset"
      collapsible="icon"
      mode="slideover"
      :ui="{ root: 'bg-transparent', container: 'border-none bg-elevated shadow-sm backdrop-blur-none', gap: 'bg-transparent' }"
    >
      <template #header="{ state }">
        <NuxtLink
          to="/admin"
          class="flex items-center gap-3 rounded-xl px-2 py-3 focus-visible:outline-2 focus-visible:outline-primary"
        >
          <img
            src="/mark.webp"
            alt=""
            class="size-10 object-contain"
          >
          <span
            v-if="state === 'expanded'"
            class="text-lg font-extrabold tracking-[0.16em] text-highlighted"
          >DISQAM</span>
        </NuxtLink>
      </template>

      <template #default="{ state, close }">
        <div class="space-y-7 px-2 py-4">
          <div>
            <p
              v-if="state === 'expanded'"
              class="disqam-eyebrow mb-3 px-3 text-[0.68rem]"
            >
              Main
            </p>
            <UNavigationMenu
              :items="mainItems"
              :collapsed="state === 'collapsed'"
              orientation="vertical"
              class="w-full"
              @click="close"
            />
          </div>
          <div>
            <p
              v-if="state === 'expanded'"
              class="disqam-eyebrow mb-3 px-3 text-[0.68rem]"
            >
              Data
            </p>
            <UNavigationMenu
              :items="dataItems"
              :collapsed="state === 'collapsed'"
              orientation="vertical"
              class="w-full"
              @click="close"
            />
          </div>
        </div>
      </template>

      <template #footer="{ state }">
        <div class="border-t border-muted px-2 pt-4">
          <div
            v-if="state === 'expanded'"
            class="mb-3 px-3"
          >
            <p class="text-sm font-semibold text-highlighted">
              {{ auth.user?.email || 'Admin DISQAM' }}
            </p>
            <p class="text-xs text-muted">
              Akses monitoring
            </p>
          </div>
          <UButton
            :icon="state === 'collapsed' ? 'i-lucide-log-out' : undefined"
            :label="state === 'expanded' ? 'Keluar' : undefined"
            color="error"
            variant="soft"
            block
            :loading="pendingLogout"
            @click="logout"
          />
        </div>
      </template>
    </USidebar>

    <main class="min-w-0 flex-1">
      <header class="sticky top-0 z-20 flex h-16 items-center justify-between border-b border-muted/70 bg-default/90 px-4 backdrop-blur md:px-8">
        <UButton
          icon="i-lucide-panel-left"
          color="neutral"
          variant="ghost"
          aria-label="Buka menu"
          class="lg:hidden"
          @click="sidebarOpen = true"
        />
        <div class="hidden items-center gap-3 lg:flex">
          <span class="size-2 rounded-full bg-primary" />
          <span class="text-sm font-semibold text-muted">Ruang monitoring DISQAM</span>
        </div>
        <div class="flex items-center gap-3">
          <UColorModeButton aria-label="Ubah tema warna" />
          <span class="hidden text-sm text-muted sm:inline">{{ auth.user?.email }}</span>
          <div class="size-9 rounded-full bg-primary/15 text-center text-sm font-bold leading-9 text-primary">
            {{ auth.user?.email?.slice(0, 1).toUpperCase() || 'A' }}
          </div>
        </div>
      </header>
      <div class="px-4 py-6 md:px-8 md:py-10 xl:px-12">
        <slot />
      </div>
    </main>
  </div>
</template>
