import ExcelJS from 'exceljs'
import { and, asc, eq, gte, lte } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participants, sleepDiaries } from '../db/schema'
import { AuthError } from './auth-policy'
import { diaryMetrics, validDate } from './participant-monitoring'

export type ParticipantExportPeriod = {
  from: string
  to: string
}

export type ParticipantDiaryExportRow = {
  sleepDate: string
  bedTime: string
  sleepStartTime: string | null
  nightAwakenings: number | null
  totalAwakeMinutes: number | null
  finalWakeTime: string
  outOfBedTime: string
  napMinutes: number | null
}

export type ParticipantDiaryExportProfile = {
  code: string
  initials: string
}

function requiredDate(value: unknown, label: string) {
  const date = validDate(value, label)
  if (!date) throw new AuthError(400, `${label} harus diisi.`)
  return date
}

export function parseParticipantExportPeriod(query: Record<string, unknown>): ParticipantExportPeriod {
  const from = requiredDate(query.from, 'Tanggal mulai')
  const to = requiredDate(query.to, 'Tanggal akhir')
  if (from > to) throw new AuthError(400, 'Rentang tanggal tidak valid.')
  const days = Math.round((Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / 86_400_000) + 1
  if (days > 7) throw new AuthError(400, 'Ekspor hanya dapat memuat paling banyak 7 hari.')
  return { from, to }
}

function styleHeader(row: ExcelJS.Row) {
  row.height = 30
  row.eachCell((cell) => {
    cell.font = { name: 'Arial', size: 11, bold: true, color: { argb: 'FFFFFFFF' } }
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF0B6273' } }
    cell.alignment = { vertical: 'middle', horizontal: 'left', wrapText: true }
    cell.border = { bottom: { style: 'medium', color: { argb: 'FF45B5C1' } } }
  })
}

export async function buildParticipantDiaryWorkbook(
  profile: ParticipantDiaryExportProfile,
  rows: ParticipantDiaryExportRow[],
  period: ParticipantExportPeriod
) {
  const workbook = new ExcelJS.Workbook()
  workbook.creator = 'DISQAM'
  workbook.company = 'DISQAM'
  workbook.created = new Date()
  workbook.calcProperties.fullCalcOnLoad = true

  const daily = workbook.addWorksheet('Catatan Harian', {
    views: [{ state: 'frozen', ySplit: 1, showGridLines: false }]
  })
  daily.columns = [
    { header: 'Tanggal tidur', key: 'date', width: 16 },
    { header: 'Masuk tempat tidur', key: 'bed', width: 19 },
    { header: 'Mulai tidur', key: 'sleepStart', width: 16 },
    { header: 'Terbangun malam (kali)', key: 'awakenings', width: 22 },
    { header: 'Terjaga malam / WASO (menit)', key: 'waso', width: 28 },
    { header: 'Bangun terakhir', key: 'finalWake', width: 17 },
    { header: 'Keluar tempat tidur', key: 'outOfBed', width: 19 },
    { header: 'Tidur siang (menit)', key: 'nap', width: 19 },
    { header: 'TIB (menit)', key: 'tib', width: 14 },
    { header: 'SOL (menit)', key: 'sol', width: 14 },
    { header: 'Terjaga setelah bangun (menit)', key: 'awakeAfterWake', width: 28 },
    { header: 'TST (menit)', key: 'tst', width: 14 },
    { header: 'Efisiensi tidur', key: 'efficiency', width: 18 },
    { header: 'Kelengkapan', key: 'complete', width: 17 }
  ]
  styleHeader(daily.getRow(1))

  rows.forEach((entry, index) => {
    const rowNumber = index + 2
    const metrics = diaryMetrics(entry)
    daily.addRow({
      date: new Date(`${entry.sleepDate}T00:00:00Z`),
      bed: entry.bedTime,
      sleepStart: entry.sleepStartTime,
      awakenings: entry.nightAwakenings,
      waso: entry.totalAwakeMinutes,
      finalWake: entry.finalWakeTime,
      outOfBed: entry.outOfBedTime,
      nap: entry.napMinutes,
      complete: metrics.isComplete ? 'Lengkap' : 'Belum lengkap'
    })
    daily.getCell(`I${rowNumber}`).value = {
      formula: `MOD(TIMEVALUE(G${rowNumber})-TIMEVALUE(B${rowNumber}),1)*1440`,
      result: metrics.timeInBedMinutes
    }
    if (metrics.sleepOnsetLatencyMinutes !== null) {
      daily.getCell(`J${rowNumber}`).value = {
        formula: `MOD(TIMEVALUE(C${rowNumber})-TIMEVALUE(B${rowNumber}),1)*1440`,
        result: metrics.sleepOnsetLatencyMinutes
      }
    }
    daily.getCell(`K${rowNumber}`).value = {
      formula: `MOD(TIMEVALUE(G${rowNumber})-TIMEVALUE(F${rowNumber}),1)*1440`,
      result: metrics.awakeAfterFinalWakeMinutes
    }
    if (metrics.sleepMinutes !== null && metrics.sleepEfficiency !== null) {
      daily.getCell(`L${rowNumber}`).value = {
        formula: `MAX(0,I${rowNumber}-J${rowNumber}-E${rowNumber}-K${rowNumber})`,
        result: metrics.sleepMinutes
      }
      daily.getCell(`M${rowNumber}`).value = {
        formula: `IFERROR(L${rowNumber}/I${rowNumber},"")`,
        result: metrics.sleepEfficiency / 100
      }
    }
  })

  daily.autoFilter = { from: 'A1', to: 'N1' }
  daily.getColumn('date').numFmt = 'dd mmm yyyy'
  for (const key of ['awakenings', 'waso', 'nap', 'tib', 'sol', 'awakeAfterWake', 'tst']) daily.getColumn(key).numFmt = '0'
  daily.getColumn('efficiency').numFmt = '0.0%'
  daily.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return
    row.height = 24
    row.eachCell({ includeEmpty: true }, (cell) => {
      cell.font = { name: 'Arial', size: 10, color: { argb: 'FF18323B' } }
      cell.alignment = { vertical: 'middle', horizontal: typeof cell.value === 'number' ? 'right' : 'left' }
      cell.border = { bottom: { style: 'hair', color: { argb: 'FFD9E6E9' } } }
      if (rowNumber % 2 === 0) cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFEEF7F8' } }
    })
  })
  daily.pageSetup = { orientation: 'landscape', fitToPage: true, fitToWidth: 1, fitToHeight: 0 }

  const calculated = rows.map(diaryMetrics).filter(metric => metric.sleepEfficiency !== null)
  const average = (values: number[]) => values.length ? values.reduce((sum, value) => sum + value, 0) / values.length : null
  const summary = workbook.addWorksheet('Ringkasan 7 Hari', { views: [{ showGridLines: false }] })
  summary.columns = [{ width: 30 }, { width: 28 }]
  summary.mergeCells('A1:B1')
  summary.getCell('A1').value = 'Ringkasan Tidur DISQAM'
  summary.getCell('A1').font = { name: 'Arial', size: 18, bold: true, color: { argb: 'FFFFFFFF' } }
  summary.getCell('A1').fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF0B2354' } }
  summary.getCell('A1').alignment = { vertical: 'middle', horizontal: 'left' }
  summary.getRow(1).height = 38
  const details: Array<[string, string | number | null]> = [
    ['Kode peserta', profile.code],
    ['Inisial', profile.initials],
    ['Periode', `${period.from} sampai ${period.to}`],
    ['Jumlah catatan', rows.length],
    ['Catatan yang dapat dihitung', calculated.length]
  ]
  details.forEach(([label, value]) => summary.addRow([label, value]))
  summary.addRow([])
  const metricHeader = summary.addRow(['Ringkasan', 'Nilai'])
  styleHeader(metricHeader)
  const firstDailyRow = 2
  const lastDailyRow = Math.max(rows.length + 1, 2)
  const averageTib = average(calculated.map(metric => metric.timeInBedMinutes))
  const averageTst = average(calculated.map(metric => metric.sleepMinutes!).filter(value => value >= 0))
  const averageEfficiency = average(calculated.map(metric => metric.sleepEfficiency!))
  const metricRows = [
    ['Rata-rata TIB', { formula: `IFERROR(AVERAGE('Catatan Harian'!I${firstDailyRow}:I${lastDailyRow}),"")`, result: averageTib }],
    ['Rata-rata TST', { formula: `IFERROR(AVERAGE('Catatan Harian'!L${firstDailyRow}:L${lastDailyRow}),"")`, result: averageTst }],
    ['Rata-rata efisiensi tidur', { formula: `IFERROR(AVERAGE('Catatan Harian'!M${firstDailyRow}:M${lastDailyRow}),"")`, result: averageEfficiency === null ? null : averageEfficiency / 100 }]
  ] as const
  metricRows.forEach(([label, value]) => summary.addRow([label, value]))
  summary.getCell('B9').numFmt = '0 "menit"'
  summary.getCell('B10').numFmt = '0 "menit"'
  summary.getCell('B11').numFmt = '0.0%'
  summary.eachRow((row, rowNumber) => {
    if (rowNumber === 1 || rowNumber === 8) return
    row.height = 24
    row.eachCell({ includeEmpty: true }, (cell, columnNumber) => {
      cell.font = { name: 'Arial', size: 11, bold: columnNumber === 1, color: { argb: 'FF18323B' } }
      cell.border = { bottom: { style: 'hair', color: { argb: 'FFD9E6E9' } } }
    })
  })
  summary.addRow([])
  summary.addRow(['Catatan', 'Efisiensi tidur adalah ringkasan deskriptif, bukan diagnosis. Nilai sebaiknya dilihat sebagai pola beberapa malam.'])
  summary.getCell(`B${summary.rowCount}`).alignment = { wrapText: true, vertical: 'top' }
  summary.getRow(summary.rowCount).height = 48

  return Buffer.from(await workbook.xlsx.writeBuffer())
}

export async function buildParticipantDiaryExport(participantId: string, period: ParticipantExportPeriod) {
  const [profile] = await useDatabase().select({ code: participants.code, initials: participants.initials })
    .from(participants).where(eq(participants.id, participantId)).limit(1)
  if (!profile) throw new AuthError(404, 'Data peserta tidak ditemukan.')
  const rows = await useDatabase().select({
    sleepDate: sleepDiaries.sleepDate,
    bedTime: sleepDiaries.bedTime,
    sleepStartTime: sleepDiaries.sleepStartTime,
    nightAwakenings: sleepDiaries.nightAwakenings,
    totalAwakeMinutes: sleepDiaries.totalAwakeMinutes,
    finalWakeTime: sleepDiaries.finalWakeTime,
    outOfBedTime: sleepDiaries.outOfBedTime,
    napMinutes: sleepDiaries.napMinutes
  }).from(sleepDiaries).where(and(
    eq(sleepDiaries.participantId, participantId),
    gte(sleepDiaries.sleepDate, period.from),
    lte(sleepDiaries.sleepDate, period.to)
  )).orderBy(asc(sleepDiaries.sleepDate))
  return {
    body: await buildParticipantDiaryWorkbook(profile, rows, period),
    filename: `disqam-ringkasan-tidur-${profile.code}-${period.from}-${period.to}.xlsx`
  }
}
