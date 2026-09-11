<script setup lang="ts">
definePageMeta({ middleware: 'admin', layout: 'admin-shell' })
</script>

<template>
  <div class="mx-auto max-w-4xl space-y-8">
    <header>
      <p class="disqam-eyebrow">
        DATA
      </p>
      <h1 class="mt-2 text-3xl font-bold text-highlighted">
        Ekspor data
      </h1>
      <p class="mt-3 max-w-2xl leading-7 text-muted">
        Unduh catatan tidur pseudonim untuk keperluan monitoring dan penelitian.
      </p>
    </header>
    <UCard>
      <div class="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-lg font-semibold text-highlighted">
            Sleep diary dalam CSV
          </p>
          <p class="mt-2 text-muted">
            Kolom menggunakan nama yang mudah dibaca dan tidak menyertakan ID database internal.
          </p>
        </div>
        <UButton
          to="/api/admin/export"
          icon="i-lucide-download"
          color="primary"
          target="_blank"
        >
          Unduh CSV
        </UButton>
      </div>
    </UCard>
  </div>
</template>
