<script setup lang="ts">
defineProps<{ eyebrow: string, title: string, description: string, icon: string }>()
</script>

<template>
  <div class="mx-auto max-w-5xl">
    <div class="night-surface rounded-[24px] p-8 md:p-12">
      <UIcon
        :name="icon"
        class="size-10 text-disqam-200"
      />
      <p class="mt-8 text-sm font-bold uppercase tracking-[0.15em] text-disqam-200">
        {{ eyebrow }}
      </p>
      <h1 class="mt-3 text-4xl font-bold text-white">
        {{ title }}
      </h1>
      <p class="mt-4 max-w-2xl text-base leading-7 text-disqam-100">
        {{ description }}
      </p>
    </div>
    <div class="mt-6 rounded-2xl border border-muted bg-elevated p-6 md:p-8">
      <p class="disqam-eyebrow">
        TAHAP BERIKUTNYA
      </p>
      <h2 class="mt-2 text-2xl font-bold text-highlighted">
        Ruang ini sedang disiapkan.
      </h2>
      <p class="mt-3 max-w-2xl leading-7 text-muted">
        Struktur navigasi sudah tersedia agar alur monitoring tetap jelas. Data akan dihubungkan setelah kebutuhan tampilan dan kontrak API bagian ini disepakati.
      </p>
    </div>
  </div>
</template>
