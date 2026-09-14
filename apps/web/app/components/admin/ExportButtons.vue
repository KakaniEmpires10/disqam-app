<script setup lang="ts">
type Dataset = 'participants' | 'progress' | 'diary'

const props = defineProps<{
  dataset: Dataset
  query?: Record<string, string | undefined>
  label?: string
}>()
const activeFormat = ref<'csv' | 'xlsx' | null>(null)
const toast = useToast()

function exportUrl(format: 'csv' | 'xlsx') {
  const params = new URLSearchParams({ dataset: props.dataset, format })
  for (const [key, value] of Object.entries(props.query || {})) {
    if (value) params.set(key, value)
  }
  return `/api/admin/export?${params.toString()}`
}

async function download(format: 'csv' | 'xlsx') {
  activeFormat.value = format
  try {
    const response = await fetch(exportUrl(format), { credentials: 'same-origin' })
    if (!response.ok) throw new Error('Export failed')
    const blob = await response.blob()
    const disposition = response.headers.get('content-disposition') || ''
    const filename = disposition.match(/filename="([^"]+)"/)?.[1] || `disqam-export.${format}`
    const url = URL.createObjectURL(blob)
    const anchor = document.createElement('a')
    anchor.href = url
    anchor.download = filename
    document.body.appendChild(anchor)
    anchor.click()
    anchor.remove()
    URL.revokeObjectURL(url)
  } catch {
    toast.add({
      title: 'Data belum dapat diunduh',
      description: 'Periksa koneksi lalu coba lagi.',
      color: 'error',
      icon: 'i-lucide-circle-alert'
    })
  } finally {
    activeFormat.value = null
  }
}
</script>

<template>
  <div class="flex flex-wrap items-center gap-2">
    <UFieldGroup>
      <UButton
        color="neutral"
        variant="outline"
        icon="i-lucide-file-text"
        :loading="activeFormat === 'csv'"
        :disabled="activeFormat !== null"
        @click="download('csv')"
      >
        {{ label ? `${label} CSV` : 'CSV' }}
      </UButton>
      <UButton
        color="primary"
        icon="i-lucide-file-spreadsheet"
        :loading="activeFormat === 'xlsx'"
        :disabled="activeFormat !== null"
        @click="download('xlsx')"
      >
        {{ label ? `${label} Excel` : 'Excel' }}
      </UButton>
    </UFieldGroup>

    <UPopover>
      <UButton
        label="Panduan format"
        icon="i-lucide-circle-help"
        color="neutral"
        variant="ghost"
      />

      <template #content>
        <div class="w-80 max-w-[calc(100vw-2rem)] space-y-4 p-4">
          <div>
            <p class="font-semibold text-highlighted">
              Pilih format sesuai kebutuhan
            </p>
            <p class="mt-1 text-sm leading-6 text-muted">
              Keduanya berisi data yang sama, tetapi disiapkan untuk penggunaan yang berbeda.
            </p>
          </div>

          <div class="flex gap-3">
            <UIcon
              name="i-lucide-file-text"
              class="mt-0.5 size-5 shrink-0 text-muted"
            />
            <div>
              <p class="font-medium text-highlighted">
                CSV untuk mengolah data
              </p>
              <p class="mt-1 text-sm leading-6 text-muted">
                Gunakan untuk impor ke database atau aplikasi analisis. Tampilannya sederhana agar mudah diproses sistem.
              </p>
            </div>
          </div>

          <div class="flex gap-3">
            <UIcon
              name="i-lucide-file-spreadsheet"
              class="mt-0.5 size-5 shrink-0 text-primary"
            />
            <div>
              <p class="font-medium text-highlighted">
                Excel untuk membaca data
              </p>
              <p class="mt-1 text-sm leading-6 text-muted">
                Gunakan untuk melihat tabel yang sudah dirapikan di Microsoft Excel atau aplikasi spreadsheet lainnya.
              </p>
            </div>
          </div>
        </div>
      </template>
    </UPopover>
  </div>
</template>
