<script setup lang="ts">
const title = 'DISQAM · Monitoring'
const description = 'Ruang monitoring program tidur DISQAM.'

useHead({
  meta: [{ name: 'viewport', content: 'width=device-width, initial-scale=1' }],
  link: [{ rel: 'icon', href: '/favicon.ico' }],
  htmlAttrs: { lang: 'id' }
})

useSeoMeta({ title, description, ogTitle: title, ogDescription: description })
</script>

<template>
  <UApp>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </UApp>
</template>
