<script setup lang="ts">
import type { NavigationMenuItem } from '@nuxt/ui'

const auth = useAdminAuth()
const adminEmail = computed(() => auth.user.value?.email)
const sidebarVariant = ref<'sidebar' | 'floating' | 'inset'>('inset')
const sidebarOpen = useState('admin-sidebar-open', () => true)
const pendingLogout = ref(false)

const mainItems: NavigationMenuItem[] = [
  { label: 'Dashboard', icon: 'i-lucide-layout-dashboard', to: '/admin' },
  { label: 'Peserta', icon: 'i-lucide-users-round', to: '/admin/participants' },
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

function handleNavigation(close: () => void) {
  if (import.meta.client && window.matchMedia('(max-width: 1023px)').matches) close()
}
</script>

<template>
  <div
    class="flex min-h-svh flex-1"
    :data-variant="sidebarVariant"
    :class="sidebarVariant === 'inset' ? 'bg-muted' : 'bg-default'"
  >
    <USidebar
      v-model:open="sidebarOpen"
      :variant="sidebarVariant"
      collapsible="icon"
      mode="slideover"
      :ui="{ container: 'h-full' }"
    >
      <template #header="{ state }">
        <NuxtLink
          to="/admin"
          class="flex min-w-0 items-center gap-3 rounded-lg focus-visible:outline-2 focus-visible:outline-primary"
        >
          <img
            src="/mark.webp"
            alt=""
            class="size-8 shrink-0 object-contain"
          >
          <span
            v-if="state === 'expanded'"
            class="text-lg font-extrabold tracking-[0.16em] text-highlighted"
          >DISQAM</span>
        </NuxtLink>
      </template>

      <template #default="{ state, close }">
        <div class="space-y-6">
          <div>
            <p
              v-if="state === 'expanded'"
              class="disqam-eyebrow mb-3 px-2 text-[0.68rem]"
            >
              Main
            </p>
            <UNavigationMenu
              :items="mainItems"
              :collapsed="state === 'collapsed'"
              orientation="vertical"
              class="w-full"
              @click="handleNavigation(close)"
            />
          </div>
          <div>
            <p
              v-if="state === 'expanded'"
              class="disqam-eyebrow mb-3 px-2 text-[0.68rem]"
            >
              Data
            </p>
            <UNavigationMenu
              :items="dataItems"
              :collapsed="state === 'collapsed'"
              orientation="vertical"
              class="w-full"
              @click="handleNavigation(close)"
            />
          </div>
        </div>
      </template>

      <template #footer="{ state }">
        <div class="flex w-full min-w-0 flex-col gap-3">
          <div
            v-if="state === 'expanded'"
            class="min-w-0 px-1"
          >
            <p class="text-sm font-semibold text-highlighted">
              {{ adminEmail || 'Admin DISQAM' }}
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

    <main
      :data-variant="sidebarVariant"
      class="flex min-w-0 flex-1 flex-col overflow-hidden bg-default lg:data-[variant=floating]:my-4 data-[variant=inset]:m-4 data-[variant=inset]:rounded-xl data-[variant=inset]:shadow-sm data-[variant=inset]:ring data-[variant=inset]:ring-default lg:data-[variant=inset]:ms-0"
    >
      <header
        class="h-(--ui-header-height) shrink-0 flex items-center justify-between px-4 md:px-8"
        :class="sidebarVariant !== 'floating' && 'border-b border-default'"
      >
        <UButton
          icon="i-lucide-panel-left"
          color="neutral"
          variant="ghost"
          :aria-label="sidebarOpen ? 'Ciutkan sidebar' : 'Buka sidebar'"
          @click="sidebarOpen = !sidebarOpen"
        />
        <div class="hidden items-center gap-3 lg:flex">
          <span class="size-2 rounded-full bg-primary" />
          <span class="text-sm font-semibold text-muted">Ruang monitoring DISQAM</span>
        </div>
        <div class="flex items-center gap-3">
          <UColorModeButton aria-label="Ubah tema warna" />
          <span class="hidden text-sm text-muted sm:inline">{{ adminEmail }}</span>
        </div>
      </header>
      <div class="flex-1 overflow-auto px-4 py-6 md:px-8 md:py-10 xl:px-12">
        <slot />
      </div>
    </main>
  </div>
</template>
