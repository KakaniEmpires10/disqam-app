import ExcelJS from 'exceljs'
import { and, desc, eq, gte, ilike, lte, or, sql, type SQL } from 'drizzle-orm'
import { useDatabase } from '../db'
import { participantProgress, participants, sleepDiaries } from '../db/schema'
import { AuthError } from './auth-policy'
import { diaryMetrics, participantGenderFilter, participantProgressFilter, progressStats, validDate } from './participant-monitoring'
import { PROGRAM_SESSIONS } from './participant-policy'

export type ExportDataset = 'participants' | 'progress' | 'diary'
export type ExportFormat = 'csv' | 'xlsx'

export type ExportColumn = {
  key: string
  csvHeader: string
  xlsxHeader: string
  width: number
  numberFormat?: string
}

export type ExportTable = {
  sheetName: string
  filename: string
  columns: ExportColumn[]
  rows: Array<Record<string, string | number | boolean | Date | null>>
}

type ExportRequest = {
  dataset: ExportDataset
  format: ExportFormat
  code?: string
  from?: string
  to?: string
  search?: string
  gender?: ReturnType<typeof participantGenderFilter>
  progress?: ReturnType<typeof participantProgressFilter>
}

function queryString(value: unknown) {
  return typeof value === 'string' && value.trim() ? value.trim() : undefined
}

export function parseExportRequest(query: Record<string, unknown>): ExportRequest {
  const dataset = queryString(query.dataset) || 'diary'
  const format = queryString(query.format) || 'csv'
  if (!['participants', 'progress', 'diary'].includes(dataset)) throw new AuthError(400, 'Jenis data ekspor tidak valid.')
  if (!['csv', 'xlsx'].includes(format)) throw new AuthError(400, 'Format ekspor tidak valid.')

  const code = queryString(query.code)
  if (code && !/^DQ-[A-HJ-NP-Z2-9]{8,16}$/.test(code)) throw new AuthError(400, 'Kode peserta tidak valid.')
  const from = validDate(queryString(query.from), 'Tanggal mulai')
  const to = validDate(queryString(query.to), 'Tanggal akhir')
  if (from && to && from > to) throw new AuthError(400, 'Rentang tanggal tidak valid.')

  return {
    dataset: dataset as ExportDataset,
    format: format as ExportFormat,
    code,
    from,
    to,
    search: queryString(query.search)?.slice(0, 80),
    gender: participantGenderFilter(queryString(query.gender)),
    progress: participantProgressFilter(queryString(query.progress))
  }
}

async function participantTable(request: ExportRequest): Promise<ExportTable> {
  const stats = progressStats()
  const conditions: SQL[] = []
  if (request.search) conditions.push(or(
    ilike(participants.code, `%${request.search}%`),
    ilike(participants.initials, `%${request.search}%`)
  )!)
  if (request.gender) conditions.push(eq(participants.gender, request.gender))
  if (request.progress === 'not-started') conditions.push(sql`coalesce(${stats.opened}, 0) = 0`)
  if (request.progress === 'in-progress') conditions.push(sql`coalesce(${stats.opened}, 0) > 0 and coalesce(${stats.completed}, 0) < 6`)
  if (request.progress === 'completed') conditions.push(sql`coalesce(${stats.completed}, 0) = 6`)

  const records = await useDatabase().select({
    code: participants.code,
    initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment,
    gender: participants.gender,
    registeredAt: participants.createdAt,
    openedSessions: sql<number>`coalesce(${stats.opened}, 0)`.mapWith(Number),
    completedSessions: sql<number>`coalesce(${stats.completed}, 0)`.mapWith(Number),
    lastLearningActivityAt: stats.lastActivity
  }).from(participants).leftJoin(stats, eq(stats.participantId, participants.id))
    .where(conditions.length ? and(...conditions) : undefined)
    .orderBy(participants.code)

  return {
    sheetName: 'Peserta',
    filename: 'disqam-peserta',
    columns: [
      { key: 'participant_code', csvHeader: 'participant_code', xlsxHeader: 'Kode peserta', width: 20 },
      { key: 'initials', csvHeader: 'initials', xlsxHeader: 'Inisial', width: 12 },
      { key: 'age_at_enrollment', csvHeader: 'age_at_enrollment', xlsxHeader: 'Usia saat bergabung', width: 20, numberFormat: '0' },
      { key: 'gender', csvHeader: 'gender', xlsxHeader: 'Jenis kelamin', width: 18 },
      { key: 'registered_at', csvHeader: 'registered_at', xlsxHeader: 'Terdaftar pada', width: 22, numberFormat: 'dd mmm yyyy hh:mm' },
      { key: 'opened_sessions', csvHeader: 'opened_sessions', xlsxHeader: 'Sesi dibuka', width: 14, numberFormat: '0' },
      { key: 'completed_sessions', csvHeader: 'completed_sessions', xlsxHeader: 'Sesi selesai', width: 14, numberFormat: '0' },
      { key: 'last_learning_activity_at', csvHeader: 'last_learning_activity_at', xlsxHeader: 'Aktivitas belajar terakhir', width: 25, numberFormat: 'dd mmm yyyy hh:mm' }
    ],
    rows: records.map(record => ({
      participant_code: record.code,
      initials: record.initials,
      age_at_enrollment: record.ageAtEnrollment,
      gender: request.format === 'xlsx' ? ({ male: 'Laki-laki', female: 'Perempuan', unspecified: 'Tidak diisi' }[record.gender || ''] || 'Tidak diisi') : record.gender,
      registered_at: request.format === 'xlsx' ? record.registeredAt : record.registeredAt.toISOString(),
      opened_sessions: record.openedSessions,
      completed_sessions: record.completedSessions,
      last_learning_activity_at: request.format === 'xlsx' ? record.lastLearningActivityAt : record.lastLearningActivityAt?.toISOString() || null
    }))
  }
}

async function progressTable(request: ExportRequest): Promise<ExportTable> {
  const [participantRows, progressRows] = await Promise.all([
    useDatabase().select({ id: participants.id, code: participants.code, initials: participants.initials })
      .from(participants).orderBy(participants.code),
    useDatabase().select({
      participantId: participantProgress.participantId,
      sessionNumber: participantProgress.sessionNumber,
      firstOpenedAt: participantProgress.firstOpenedAt,
      lastOpenedAt: participantProgress.lastOpenedAt,
      completedAt: participantProgress.completedAt
    }).from(participantProgress)
  ])
  const progressByParticipant = new Map<string, Map<number, typeof progressRows[number]>>()
  for (const row of progressRows) {
    const entries = progressByParticipant.get(row.participantId) || new Map()
    entries.set(row.sessionNumber, row)
    progressByParticipant.set(row.participantId, entries)
  }

  const rows = participantRows.flatMap(participant => PROGRAM_SESSIONS.map((session) => {
    const progress = progressByParticipant.get(participant.id)?.get(session.number)
    const status = progress?.completedAt ? 'completed' : progress ? 'opened' : 'not_opened'
    return {
      participant_code: participant.code,
      initials: participant.initials,
      session_number: session.number,
      session_title: session.title,
      status: request.format === 'xlsx' ? ({ completed: 'Selesai', opened: 'Sudah dibuka', not_opened: 'Belum dibuka' }[status]!) : status,
      first_opened_at: request.format === 'xlsx' ? progress?.firstOpenedAt || null : progress?.firstOpenedAt.toISOString() || null,
      last_opened_at: request.format === 'xlsx' ? progress?.lastOpenedAt || null : progress?.lastOpenedAt.toISOString() || null,
      completed_at: request.format === 'xlsx' ? progress?.completedAt || null : progress?.completedAt?.toISOString() || null
    }
  }))

  return {
    sheetName: 'Progress Program',
    filename: 'disqam-progress-program',
    columns: [
      { key: 'participant_code', csvHeader: 'participant_code', xlsxHeader: 'Kode peserta', width: 20 },
      { key: 'initials', csvHeader: 'initials', xlsxHeader: 'Inisial', width: 12 },
      { key: 'session_number', csvHeader: 'session_number', xlsxHeader: 'Nomor sesi', width: 12, numberFormat: '0' },
      { key: 'session_title', csvHeader: 'session_title', xlsxHeader: 'Judul sesi', width: 42 },
      { key: 'status', csvHeader: 'status', xlsxHeader: 'Status', width: 16 },
      { key: 'first_opened_at', csvHeader: 'first_opened_at', xlsxHeader: 'Pertama dibuka', width: 22, numberFormat: 'dd mmm yyyy hh:mm' },
      { key: 'last_opened_at', csvHeader: 'last_opened_at', xlsxHeader: 'Terakhir dibuka', width: 22, numberFormat: 'dd mmm yyyy hh:mm' },
      { key: 'completed_at', csvHeader: 'completed_at', xlsxHeader: 'Diselesaikan pada', width: 22, numberFormat: 'dd mmm yyyy hh:mm' }
    ],
    rows
  }
}

async function diaryTable(request: ExportRequest): Promise<ExportTable> {
  const conditions: SQL[] = []
  if (request.code) conditions.push(eq(participants.code, request.code))
  if (request.from) conditions.push(gte(sleepDiaries.sleepDate, request.from))
  if (request.to) conditions.push(lte(sleepDiaries.sleepDate, request.to))

  const records = await useDatabase().select({
    code: participants.code,
    initials: participants.initials,
    ageAtEnrollment: participants.ageAtEnrollment,
    gender: participants.gender,
    sleepDate: sleepDiaries.sleepDate,
    bedTime: sleepDiaries.bedTime,
    sleepStartTime: sleepDiaries.sleepStartTime,
    nightAwakenings: sleepDiaries.nightAwakenings,
    totalAwakeMinutes: sleepDiaries.totalAwakeMinutes,
    finalWakeTime: sleepDiaries.finalWakeTime,
    outOfBedTime: sleepDiaries.outOfBedTime,
    napMinutes: sleepDiaries.napMinutes,
    createdAt: sleepDiaries.createdAt,
    updatedAt: sleepDiaries.updatedAt
  }).from(sleepDiaries).innerJoin(participants, eq(participants.id, sleepDiaries.participantId))
    .where(conditions.length ? and(...conditions) : undefined)
    .orderBy(participants.code, desc(sleepDiaries.sleepDate))

  return {
    sheetName: 'Buku Harian Tidur',
    filename: `disqam-buku-harian${request.code ? `-${request.code}` : ''}`,
    columns: [
      { key: 'participant_code', csvHeader: 'participant_code', xlsxHeader: 'Kode peserta', width: 20 },
      { key: 'initials', csvHeader: 'initials', xlsxHeader: 'Inisial', width: 12 },
      { key: 'age_at_enrollment', csvHeader: 'age_at_enrollment', xlsxHeader: 'Usia saat bergabung', width: 20, numberFormat: '0' },
      { key: 'gender', csvHeader: 'gender', xlsxHeader: 'Jenis kelamin', width: 18 },
      { key: 'sleep_date', csvHeader: 'sleep_date', xlsxHeader: 'Tanggal tidur', width: 16 },
      { key: 'bed_time', csvHeader: 'bed_time', xlsxHeader: 'Masuk tempat tidur', width: 19 },
      { key: 'sleep_start_time', csvHeader: 'sleep_start_time', xlsxHeader: 'Mulai tidur', width: 16 },
      { key: 'night_awakenings', csvHeader: 'night_awakenings', xlsxHeader: 'Terbangun malam (kali)', width: 22, numberFormat: '0' },
      { key: 'total_awake_minutes', csvHeader: 'total_awake_minutes', xlsxHeader: 'Total terjaga (menit)', width: 21, numberFormat: '0' },
      { key: 'final_wake_time', csvHeader: 'final_wake_time', xlsxHeader: 'Bangun terakhir', width: 17 },
      { key: 'out_of_bed_time', csvHeader: 'out_of_bed_time', xlsxHeader: 'Keluar tempat tidur', width: 19 },
      { key: 'nap_minutes', csvHeader: 'nap_minutes', xlsxHeader: 'Tidur siang (menit)', width: 19, numberFormat: '0' },
      { key: 'time_in_bed_minutes', csvHeader: 'time_in_bed_minutes', xlsxHeader: 'Di tempat tidur (menit)', width: 22, numberFormat: '0' },
      { key: 'sleep_minutes', csvHeader: 'sleep_minutes', xlsxHeader: 'Perkiraan tidur (menit)', width: 22, numberFormat: '0' },
      { key: 'sleep_efficiency_percent', csvHeader: 'sleep_efficiency_percent', xlsxHeader: 'Efisiensi tidur (%)', width: 19, numberFormat: '0.0' },
      { key: 'is_complete', csvHeader: 'is_complete', xlsxHeader: 'Data lengkap', width: 15 },
      { key: 'created_at', csvHeader: 'created_at', xlsxHeader: 'Dibuat pada', width: 22, numberFormat: 'dd mmm yyyy hh:mm' },
      { key: 'updated_at', csvHeader: 'updated_at', xlsxHeader: 'Diperbarui pada', width: 22, numberFormat: 'dd mmm yyyy hh:mm' }
    ],
    rows: records.map((record) => {
      const metrics = diaryMetrics(record)
      return {
        participant_code: record.code,
        initials: record.initials,
        age_at_enrollment: record.ageAtEnrollment,
        gender: request.format === 'xlsx' ? ({ male: 'Laki-laki', female: 'Perempuan', unspecified: 'Tidak diisi' }[record.gender || ''] || 'Tidak diisi') : record.gender,
        sleep_date: record.sleepDate,
        bed_time: record.bedTime,
        sleep_start_time: record.sleepStartTime,
        night_awakenings: record.nightAwakenings,
        total_awake_minutes: record.totalAwakeMinutes,
        final_wake_time: record.finalWakeTime,
        out_of_bed_time: record.outOfBedTime,
        nap_minutes: record.napMinutes,
        time_in_bed_minutes: metrics.timeInBedMinutes,
        sleep_minutes: metrics.sleepMinutes,
        sleep_efficiency_percent: metrics.sleepEfficiency,
        is_complete: metrics.isComplete,
        created_at: request.format === 'xlsx' ? record.createdAt : record.createdAt.toISOString(),
        updated_at: request.format === 'xlsx' ? record.updatedAt : record.updatedAt.toISOString()
      }
    })
  }
}

function csvCell(value: unknown) {
  const text = value === null || value === undefined ? '' : String(value)
  return `"${text.replaceAll('"', '""')}"`
}

export function buildCsv(table: ExportTable) {
  const header = table.columns.map(column => csvCell(column.csvHeader)).join(',')
  const rows = table.rows.map(row => table.columns.map(column => csvCell(row[column.key])).join(','))
  return [header, ...rows].join('\r\n')
}

export async function buildXlsx(table: ExportTable) {
  const workbook = new ExcelJS.Workbook()
  workbook.creator = 'DISQAM'
  workbook.company = 'DISQAM'
  workbook.created = new Date()
  const worksheet = workbook.addWorksheet(table.sheetName, {
    views: [{ state: 'frozen', ySplit: 1, showGridLines: false }]
  })
  worksheet.columns = table.columns.map(column => ({
    header: column.xlsxHeader,
    key: column.key,
    width: column.width,
    style: column.numberFormat ? { numFmt: column.numberFormat } : undefined
  }))
  worksheet.addRows(table.rows)
  worksheet.autoFilter = { from: 'A1', to: { row: 1, column: table.columns.length } }

  const header = worksheet.getRow(1)
  header.height = 30
  header.eachCell((cell) => {
    cell.font = { name: 'Arial', size: 11, bold: true, color: { argb: 'FFFFFFFF' } }
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF0B6273' } }
    cell.alignment = { vertical: 'middle', horizontal: 'left' }
    cell.border = { bottom: { style: 'medium', color: { argb: 'FF45B5C1' } } }
  })
  worksheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return
    row.height = 22
    row.eachCell({ includeEmpty: true }, (cell) => {
      cell.font = { name: 'Arial', size: 10, color: { argb: 'FF18323B' } }
      cell.alignment = { vertical: 'middle', horizontal: typeof cell.value === 'number' ? 'right' : 'left' }
      cell.border = { bottom: { style: 'hair', color: { argb: 'FFD9E6E9' } } }
      if (rowNumber % 2 === 0) cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFEEF7F8' } }
    })
  })
  worksheet.pageSetup = { orientation: 'landscape', fitToPage: true, fitToWidth: 1, fitToHeight: 0 }
  worksheet.headerFooter.oddFooter = '&LDISQAM&CData penelitian&RHalaman &P dari &N'
  return Buffer.from(await workbook.xlsx.writeBuffer())
}

export async function buildAdminExport(request: ExportRequest) {
  const table = request.dataset === 'participants'
    ? await participantTable(request)
    : request.dataset === 'progress'
      ? await progressTable(request)
      : await diaryTable(request)
  const date = new Date().toISOString().slice(0, 10)
  if (request.format === 'xlsx') {
    return {
      body: await buildXlsx(table),
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      filename: `${table.filename}-${date}.xlsx`
    }
  }
  return {
    body: buildCsv(table),
    contentType: 'text/csv; charset=utf-8',
    filename: `${table.filename}-${date}.csv`
  }
}
