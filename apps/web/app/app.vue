<script setup lang="ts">
import type { ToasterProps } from '@nuxt/ui'

const title = 'DISQAM · Monitoring'
const description = 'Ruang monitoring program tidur DISQAM.'

useHead({
  meta: [{ name: 'viewport', content: 'width=device-width, initial-scale=1' }],
  link: [{ rel: 'icon', type: 'image/webp', href: '/mark.webp' }],
  htmlAttrs: { lang: 'id' }
})

useSeoMeta({ title, description, ogTitle: title, ogDescription: description })

const toastOption: ToasterProps = {
  position: 'top-center'
}
</script>

<template>
  <UApp :toaster="toastOption">
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </UApp>
</template>
