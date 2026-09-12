import assert from 'node:assert/strict'
import test from 'node:test'
import ExcelJS from 'exceljs'
import { buildCsv, buildXlsx, parseExportRequest, type ExportTable } from '../server/services/admin-export'
import { AuthError } from '../server/services/auth-policy'
import { buildParticipantDiaryWorkbook, parseParticipantExportPeriod } from '../server/services/participant-export'

test('export request defaults to diary CSV for backwards compatibility', () => {
  const request = parseExportRequest({})
  assert.equal(request.dataset, 'diary')
  assert.equal(request.format, 'csv')
})

test('export request accepts relevant participant and diary filters', () => {
  const participants = parseExportRequest({
    dataset: 'participants',
    format: 'xlsx',
    search: ' DQ-ABC ',
    gender: 'female',
    progress: 'in-progress'
  })
  assert.equal(participants.search, 'DQ-ABC')
  assert.equal(participants.gender, 'female')
  assert.equal(participants.progress, 'in-progress')

  const diary = parseExportRequest({
    dataset: 'diary',
    format: 'csv',
    code: 'DQ-ABCDEFGHJK',
    from: '2026-09-01',
    to: '2026-09-30'
  })
  assert.equal(diary.code, 'DQ-ABCDEFGHJK')
  assert.equal(diary.from, '2026-09-01')
  assert.equal(diary.to, '2026-09-30')
})

test('export request rejects unsupported formats and invalid filters', () => {
  for (const query of [
    { dataset: 'admins' },
    { format: 'pdf' },
    { code: '1' },
    { from: '2026-02-30' },
    { from: '2026-10-01', to: '2026-09-01' },
    { gender: 'unknown' },
    { progress: 'almost-done' }
  ]) assert.throws(() => parseExportRequest(query), AuthError)
})

test('CSV stays machine-friendly and XLSX keeps its reading aids', async () => {
  const table: ExportTable = {
    sheetName: 'Peserta',
    filename: 'disqam-peserta',
    columns: [
      { key: 'participant_code', csvHeader: 'participant_code', xlsxHeader: 'Kode peserta', width: 20 },
      { key: 'registered_at', csvHeader: 'registered_at', xlsxHeader: 'Terdaftar pada', width: 22, numberFormat: 'dd mmm yyyy hh:mm' }
    ],
    rows: [{ participant_code: 'DQ-ABCDEFGHJK', registered_at: new Date('2026-09-11T08:00:00Z') }]
  }
  const csv = buildCsv(table)
  assert.ok(csv.startsWith('"participant_code","registered_at"'))
  assert.equal(csv.charCodeAt(0), '"'.charCodeAt(0))

  const workbook = new ExcelJS.Workbook()
  await workbook.xlsx.load(await buildXlsx(table))
  const sheet = workbook.getWorksheet('Peserta')!
  assert.equal(sheet.getCell('A1').value, 'Kode peserta')
  assert.equal(sheet.getCell('A2').value, 'DQ-ABCDEFGHJK')
  assert.equal(sheet.getCell('A1').font.bold, true)
  assert.equal(sheet.getCell('A1').fill.type, 'pattern')
  assert.equal(sheet.getCell('B2').numFmt, 'dd mmm yyyy hh:mm')
  assert.equal(sheet.views[0]?.state, 'frozen')
  assert.equal(sheet.views[0]?.ySplit, 1)
  assert.ok(sheet.autoFilter)
})

test('participant export accepts at most seven inclusive calendar days', () => {
  assert.deepEqual(
    parseParticipantExportPeriod({ from: '2026-09-06', to: '2026-09-12' }),
    { from: '2026-09-06', to: '2026-09-12' }
  )
  for (const query of [
    {},
    { from: '2026-09-12', to: '2026-09-06' },
    { from: '2026-09-05', to: '2026-09-12' }
  ]) assert.throws(() => parseParticipantExportPeriod(query), AuthError)
})

test('participant XLSX contains styled summary and auditable sleep formulas', async () => {
  const bytes = await buildParticipantDiaryWorkbook(
    { code: 'DQ-ABCDEFGHJK', initials: 'AB' },
    [{
      sleepDate: '2026-09-12',
      bedTime: '21:30',
      sleepStartTime: '22:00',
      nightAwakenings: 2,
      totalAwakeMinutes: 30,
      finalWakeTime: '05:45',
      outOfBedTime: '06:00',
      napMinutes: 0
    }],
    { from: '2026-09-06', to: '2026-09-12' }
  )
  const workbook = new ExcelJS.Workbook()
  await workbook.xlsx.load(bytes)
  const summary = workbook.getWorksheet('Ringkasan 7 Hari')!
  const daily = workbook.getWorksheet('Catatan Harian')!
  assert.equal(summary.getCell('B2').value, 'DQ-ABCDEFGHJK')
  assert.equal(summary.getCell('A1').font.bold, true)
  assert.equal(daily.getCell('I2').value?.toString().includes('formula'), false)
  assert.deepEqual(daily.getCell('I2').value, {
    formula: 'MOD(TIMEVALUE(G2)-TIMEVALUE(B2),1)*1440',
    result: 510
  })
  assert.deepEqual(daily.getCell('L2').value, {
    formula: 'MAX(0,I2-J2-E2-K2)',
    result: 435
  })
  assert.equal(daily.getCell('M2').numFmt, '0.0%')
  assert.ok(daily.autoFilter)
})
