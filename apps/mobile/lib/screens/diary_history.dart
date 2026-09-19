// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

import '../domain/sleep_calculator.dart';
import '../services/participant_api.dart';
import '../services/participant_export.dart';
import '../services/participant_store.dart';
import '../widgets/export_action.dart';
import '../services/reading_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'home.dart';

class DiaryHistoryPage extends StatefulWidget {
  const DiaryHistoryPage({super.key, required this.participants});
  final ParticipantStore participants;

  @override
  State<DiaryHistoryPage> createState() => _DiaryHistoryPageState();
}

class _DiaryHistoryPageState extends State<DiaryHistoryPage> {
  late DateTime periodEnd;
  bool loading = false;
  bool exporting = false;

  DateTime get periodStart => periodEnd.subtract(const Duration(days: 6));

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    periodEnd = DateTime(now.year, now.month, now.day);
  }

  String _apiDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _weekday(String date) {
    final value = DateTime.tryParse(date);
    if (value == null) return date;
    return const [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ][value.weekday - 1];
  }

  List<SleepDiaryEntry> get entries => widget.participants.diaryEntries
      .where((entry) {
        final date = DateTime.tryParse(entry.sleepDate);
        return date != null &&
            !date.isBefore(periodStart) &&
            !date.isAfter(periodEnd);
      })
      .toList(growable: false);

  SleepEfficiencyResult? _result(SleepDiaryEntry entry) {
    if (entry.sleepStartTime == null || entry.totalAwakeMinutes == null)
      return null;
    try {
      final bed = clockMinutes(entry.bedTime);
      final outOfBed = clockMinutes(entry.outOfBedTime);
      return calculateSleepEfficiency(
        bedTimeMinutes: bed,
        outOfBedMinutes: outOfBed,
        sleepOnsetLatencyMinutes: overnightMinutes(
          clockMinutes(entry.sleepStartTime!),
          bed,
        ),
        wakeAfterSleepOnsetMinutes: entry.totalAwakeMinutes!,
        otherAwakeMinutes: overnightMinutes(
          outOfBed,
          clockMinutes(entry.finalWakeTime),
        ),
      );
    } on Object {
      return null;
    }
  }

  double? _average(Iterable<double> values) {
    final items = values.toList(growable: false);
    return items.isEmpty ? null : items.reduce((a, b) => a + b) / items.length;
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    await widget.participants.loadDiary();
    if (mounted) setState(() => loading = false);
  }

  void _movePeriod(int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final candidate = periodEnd.add(Duration(days: days));
    setState(() => periodEnd = candidate.isAfter(today) ? today : candidate);
  }

  Future<void> _export() async {
    setState(() => exporting = true);
    try {
      final file = await widget.participants.exportDiary(
        from: _apiDate(periodStart),
        to: _apiDate(periodEnd),
      );
      if (!mounted) return;
      await chooseExportAction(
        context: context,
        filename: file.filename,
        bytes: file.bytes,
        mimeType: file.mimeType,
        share: () => ParticipantExport.share(file),
      );
    } on ParticipantApiException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.participants,
    builder: (context, _) {
      final items = entries;
      final results = items
          .map(_result)
          .whereType<SleepEfficiencyResult>()
          .toList();
      final averageEfficiency = _average(
        results.map((item) => item.sleepEfficiency),
      );
      final averageSleep = _average(
        results.map((item) => item.totalSleepMinutes.toDouble()),
      );
      final atTarget = results
          .where((item) => item.level == SleepEfficiencyLevel.efficient)
          .length;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return AppPage(
        title: 'Riwayat dan Ringkasan Tidur',
        eyebrow: 'PANTAU POLA TIDUR',
        subtitle: 'Lihat catatan dalam kelompok tujuh hari agar perubahan pola tidur lebih mudah dipahami.',
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DisqamColors.surfaceAlt,
              border: Border.all(color: DisqamColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Periode tujuh hari',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_displayDate(periodStart)} – ${_displayDate(periodEnd)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DisqamColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _movePeriod(-7),
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text('Lihat 7 hari sebelumnya'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: periodEnd.isBefore(today)
                      ? () => _movePeriod(7)
                      : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: const Text('Lihat 7 hari berikutnya'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Summary(
                  label: 'Catatan terisi',
                  value: '${items.length} dari 7',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Summary(
                  label: 'Rata-rata efisiensi',
                  value: averageEfficiency == null
                      ? 'Belum ada'
                      : '${averageEfficiency.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Summary(
                  label: 'Rata-rata tidur',
                  value: averageSleep == null
                      ? 'Belum ada'
                      : formatDuration(averageSleep.round()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Summary(
                  label: 'Mencapai 85%',
                  value: '$atTarget malam',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InfoBox(
            results.isEmpty
                ? 'Efisiensi dapat dihitung setelah jam mulai tidur dan lama terjaga diisi.'
                : 'Patokan umum efisiensi tidur adalah 85% atau lebih. Lihat polanya selama beberapa malam; satu hasil saja bukan diagnosis.',
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: exporting ? null : _export,
            icon: exporting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_outlined),
            label: Text(
              exporting ? 'Menyiapkan ringkasan...' : 'Unduh ringkasan Excel',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Catatan harian',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: loading ? null : _refresh,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Muat ulang',
              ),
            ],
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!loading &&
              items.isEmpty &&
              widget.participants.lastError != null)
            InfoBox(
              widget.participants.lastError!,
              warm: true,
              label: 'Data belum dapat dimuat',
            ),
          if (!loading &&
              items.isEmpty &&
              widget.participants.lastError == null)
            const InfoBox('Belum ada catatan tidur pada tujuh hari ini.'),
          for (final entry in items) _entryCard(context, entry),
        ],
      );
    },
  );

  Widget _entryCard(BuildContext context, SleepDiaryEntry entry) {
    final result = _result(entry);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: DisqamColors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: DisqamColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.nightlight_round,
                    color: DisqamColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weekday(entry.sleepDate),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        entry.sleepDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Pilihan catatan',
                  onSelected: (value) =>
                      value == 'edit' ? _edit(entry) : _delete(entry),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit catatan')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Hapus catatan'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Metric(
                  label: 'Di tempat tidur',
                  value: '${entry.bedTime}–${entry.outOfBedTime}',
                ),
                _Metric(label: 'Bangun terakhir', value: entry.finalWakeTime),
                _Metric(
                  label: 'Total tidur',
                  value: result == null
                      ? 'Belum dapat dihitung'
                      : formatDuration(result.totalSleepMinutes),
                ),
                _Metric(
                  label: 'Efisiensi',
                  value: result == null
                      ? 'Belum dapat dihitung'
                      : '${result.sleepEfficiency.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(SleepDiaryEntry entry) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DiaryPage(
          store: ReadingStore(),
          participants: widget.participants,
          initialEntry: entry,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _delete(SleepDiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan ${entry.sleepDate} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.participants.deleteDiary(entry.sleepDate);
    } on ParticipantApiException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 92),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: DisqamColors.surfaceAlt,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 138),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: DisqamColors.surfaceAlt,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    ),
  );
}
