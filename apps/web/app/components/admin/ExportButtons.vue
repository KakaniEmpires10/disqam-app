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
      {{ label ? `${label} XLSX` : 'XLSX' }}
    </UButton>
  </UFieldGroup>
</template>
