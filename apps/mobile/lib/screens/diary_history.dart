// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

import '../services/participant_api.dart';
import '../services/participant_store.dart';
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
  DateTime? from;
  DateTime? until;
  bool loading = false;
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

  List<SleepDiaryEntry> get filtered => widget.participants.diaryEntries
      .where((entry) {
        final date = DateTime.tryParse(entry.sleepDate);
        return date != null &&
            (from == null || !date.isBefore(from!)) &&
            (until == null || !date.isAfter(until!));
      })
      .toList(growable: false);
  double _average(Iterable<int?> values) {
    final present = values.whereType<int>().toList();
    return present.isEmpty
        ? 0
        : present.reduce((a, b) => a + b) / present.length;
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    await widget.participants.loadDiary();
    if (mounted) setState(() => loading = false);
  }

  Future<void> _pickDate(bool start) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: (start ? from : until) ?? DateTime.now(),
    );
    if (picked != null)
      setState(() {
        if (start)
          from = picked;
        else
          until = picked;
      });
  }

  String _formatDate(DateTime? date) => date == null
      ? 'Semua tanggal'
      : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  @override
  Widget build(BuildContext context) {
    final items = filtered;
    return ListenableBuilder(
      listenable: widget.participants,
      builder: (context, _) => AppPage(
        title: 'Riwayat Buku Harian',
        eyebrow: 'MONITOR POLA TIDUR',
        subtitle: 'Catatan lengkap peserta ini. Ringkasan berikut bersifat deskriptif, bukan penilaian klinis.',
        children: [
          Row(
            children: [
              Expanded(
                child: _Summary(label: 'Catatan', value: '${items.length}'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Summary(
                  label: 'Rata-rata terbangun',
                  value: _average(items.map((e) => e.nightAwakenings))
                      .toStringAsFixed(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Summary(
                  label: 'Rata-rata terjaga',
                  value:
                      '${_average(items.map((e) => e.totalAwakeMinutes)).round()} m',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Saring tanggal', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(true),
                  child: _FilterDateLabel(
                    label: 'Dari',
                    value: _formatDate(from),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(false),
                  child: _FilterDateLabel(
                    label: 'Sampai',
                    value: _formatDate(until),
                  ),
                ),
              ),
            ],
          ),
          if (from != null || until != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() {
                  from = null;
                  until = null;
                }),
                child: const Text('Hapus filter'),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Semua catatan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: loading ? null : _refresh,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Muat ulang',
              ),
            ],
          ),
          if (loading) const Center(child: CircularProgressIndicator()),
          if (!loading && items.isEmpty)
            const InfoBox('Belum ada catatan pada rentang tanggal ini.'),
          for (final entry in items) _entryCard(context, entry),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur ekspor akan tersedia pada tahap berikutnya.',
                ),
              ),
            ),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Ekspor riwayat (segera tersedia)'),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(BuildContext context, SleepDiaryEntry entry) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DisqamColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Decorative surface circle.
          Positioned(
            top: -46,
            right: -38,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DisqamColors.surfaceAlt.withValues(alpha: 0.9),
              ),
            ),
          ),

          // Small accent circle.
          Positioned(
            top: 26,
            right: 58,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DisqamColors.primary.withValues(alpha: 0.24),
              ),
            ),
          ),

          // Subtle rotated square.
          Positioned(
            bottom: -12,
            left: 48,
            child: Transform.rotate(
              angle: 0.35,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: DisqamColors.primary.withValues(alpha: 0.045),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _weekday(entry.sleepDate),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            entry.sleepDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        border: Border.all(color: DisqamColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _edit(entry),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit catatan',
                          ),

                          Container(
                            width: 1,
                            height: 24,
                            color: DisqamColors.border,
                          ),

                          IconButton(
                            onPressed: () => _delete(entry),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: Color(0xFFB84B4B),
                            ),
                            tooltip: 'Hapus catatan',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: DisqamColors.surfaceAlt.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _entryMetricCell(
                              context,
                              value: entry.bedTime,
                              label: 'Masuk tempat tidur',
                              icon: Icons.bedtime_outlined,
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 64,
                            color: DisqamColors.border,
                          ),

                          Expanded(
                            child: _entryMetricCell(
                              context,
                              value: entry.finalWakeTime,
                              label: 'Bangun terakhir',
                              icon: Icons.wb_sunny_outlined,
                            ),
                          ),
                        ],
                      ),

                      Container(height: 1, color: DisqamColors.border),

                      Row(
                        children: [
                          Expanded(
                            child: _entryMetricCell(
                              context,
                              value: '${entry.nightAwakenings ?? 0}',
                              label: 'Kali terbangun',
                              icon: Icons.refresh_rounded,
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 64,
                            color: DisqamColors.border,
                          ),

                          Expanded(
                            child: _entryMetricCell(
                              context,
                              value: '${entry.totalAwakeMinutes ?? 0} m',
                              label: 'Lama terjaga',
                              icon: Icons.timelapse_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _entryMetricCell(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: DisqamColors.primary),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: DisqamColors.muted, height: 1.25),
                ),
              ],
            ),
          ),
        ],
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
        content: Text(
          'Catatan ${entry.sleepDate} akan dihapus dari buku harian peserta.',
        ),
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
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: DisqamColors.surfaceAlt,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 5),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    ),
  );
}

class _FilterDateLabel extends StatelessWidget {
  const _FilterDateLabel({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      Text(
        value,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: DisqamColors.navy),
      ),
    ],
  );
}
