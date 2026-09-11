// The form keeps compact single-line callbacks for the small mobile flow.
// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/catalog.dart';
import '../content/models.dart';
import '../content/program.dart';
import '../services/reading_store.dart';
import '../services/participant_store.dart';
import '../services/participant_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'about.dart';
import 'calculator.dart';
import 'reading.dart';
import 'participant_access.dart';
import 'diary_history.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.store,
    this.participants,
    this.admin,
  });
  final ReadingStore store;
  final ParticipantStore? participants;
  final AdminStore? admin;

  Future<void> _openProgram(BuildContext context, Widget page) async {
    if (await ensureParticipantAccess(context, participants) &&
        context.mounted) {
      openPage(context, page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = findArticle(store.articleId);
    final lastSession = last?.id.startsWith('session-') == true ? last : null;
    final theme = Theme.of(context);
    return AppPage(
      isHome: true,
      showTitle: false,
      title: 'Beranda',
      headerAction: TextButton.icon(
        onPressed: () => openPage(context, AboutPage(admin: admin)),
        icon: const Icon(Icons.info_outline_rounded, size: 20),
        label: const Text('Tentang'),
      ),
      children: [
        Text(
          'Selangkah menuju\ntidur lebih baik.',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        NightSurface(
          motifSize: 160,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 70),
                child: Eyebrow('6 SESI PANDUAN', light: true),
              ),
              const SizedBox(height: 18),
              Text(
                'Program DISQAM',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lastSession?.title ??
                    'Bangun kebiasaan tidur, langkah demi langkah.',
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  color: Color(0xFFD8E9EE),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB5E5E9),
                  foregroundColor: DisqamColors.navy,
                ),
                onPressed: () => _openProgram(
                  context,
                  lastSession == null
                      ? TopicListPage(
                          group: programGroup,
                          store: store,
                          participants: participants,
                        )
                      : ReadingPage(
                          article: lastSession,
                          store: store,
                          participants: participants,
                          initialSection: store.sectionIndex,
                        ),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  lastSession == null ? 'Jelajahi program' : 'Lanjutkan sesi',
                ),
              ),
              if (lastSession != null)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () => _openProgram(
                    context,
                    TopicListPage(
                      group: programGroup,
                      store: store,
                      participants: participants,
                    ),
                  ),
                  child: const Text('Lihat semua sesi'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Material(
          color: DisqamColors.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => openPage(
              context,
              DiaryPage(store: store, participants: participants),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/diary.webp',
                    width: 52,
                    height: 52,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buku Harian Tidur',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 6),
                        const Text('Catatan tidur setiap pagi.'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: DisqamColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (last != null && lastSession == null) ...[
          const SizedBox(height: 6),
          MenuCard(
            title: 'Lanjutkan membaca',
            subtitle: last.title,
            icon: Icons.bookmark_outline_rounded,
            onTap: () => openPage(
              context,
              ReadingPage(
                article: last,
                store: store,
                initialSection: store.sectionIndex,
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        const Eyebrow('PAHAMI LEBIH DALAM'),
        const SizedBox(height: 8),
        Text('Bekal untuk tidur', style: theme.textTheme.titleLarge),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3;
            final items = [
              for (final group in [sleepGroup, cbtGroup])
                _LearningLink(
                  group: group,
                  onTap: () => openPage(
                    context,
                    TopicListPage(group: group, store: store),
                  ),
                ),
            ];
            return stacked
                ? Column(children: items)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: items[0]),
                      const SizedBox(width: 24),
                      Expanded(child: items[1]),
                    ],
                  );
          },
        ),
        const SizedBox(height: 22),
        Text('Teman perjalanan', style: theme.textTheme.titleLarge),
        MenuCard(
          title: 'Kalkulator Waktu Tidur',
          subtitle: 'Rencanakan jam tidur atau bangun.',
          icon: Icons.schedule_rounded,
          onTap: () => openPage(context, const CalculatorPage()),
        ),
        MenuCard(
          title: caregiverGroup.title,
          subtitle: 'Dukungan kecil yang berarti.',
          icon: Icons.volunteer_activism_outlined,
          onTap: () => openPage(
            context,
            TopicListPage(group: caregiverGroup, store: store),
          ),
        ),
        const SizedBox(height: 26),
        Text(
          'Materi selalu dekat, bahkan tanpa internet.',
          style: theme.textTheme.bodySmall,
        ),
        if (store.storageUnavailable) ...[
          const SizedBox(height: 18),
          const InfoBox(
            'Posisi bacaan belum berhasil disimpan di perangkat ini. Anda tetap dapat membaca seluruh materi.',
            warm: true,
          ),
        ],
      ],
    );
  }
}

class _LearningLink extends StatelessWidget {
  const _LearningLink({required this.group, required this.onTap});
  final ContentGroup group;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              group.asset,
              width: 74,
              height: 74,
              excludeFromSemantics: true,
            ),
            const SizedBox(height: 16),
            Text(group.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              group.id == 'sleep'
                  ? 'Pahami cara tubuh beristirahat.'
                  : 'Kenali hubungan pikiran dan tidur.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: DisqamColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    ),
  );
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({
    super.key,
    required this.store,
    this.participants,
    this.initialEntry,
  });
  final ReadingStore store;
  final ParticipantStore? participants;
  final SleepDiaryEntry? initialEntry;
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late DateTime date = DateTime.now();
  final bed = TextEditingController(text: '21:30');
  final sleepStart = TextEditingController(text: '22:00');
  final awakened = TextEditingController(text: '0');
  final awakeMinutes = TextEditingController(text: '0');
  final finalWake = TextEditingController(text: '05:30');
  final outOfBed = TextEditingController(text: '06:00');
  final nap = TextEditingController(text: '0');
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialEntry;
    if (initial != null) {
      date = DateTime.tryParse(initial.sleepDate) ?? date;
      bed.text = initial.bedTime;
      sleepStart.text = initial.sleepStartTime ?? '';
      awakened.text = '${initial.nightAwakenings ?? 0}';
      awakeMinutes.text = '${initial.totalAwakeMinutes ?? 0}';
      finalWake.text = initial.finalWakeTime;
      outOfBed.text = initial.outOfBedTime;
      nap.text = '${initial.napMinutes ?? 0}';
    }
    if (widget.participants?.registered == true) {
      widget.participants!.loadDiary();
    }
  }

  @override
  void dispose() {
    for (final controller in [
      bed,
      sleepStart,
      awakened,
      awakeMinutes,
      finalWake,
      outOfBed,
      nap,
    ])
      controller.dispose();
    super.dispose();
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  Future<void> _time(TextEditingController controller) async {
    final parts = controller.text.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(parts.first) ?? 21,
        minute: int.tryParse(parts.last) ?? 0,
      ),
    );
    if (picked != null)
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (widget.participants == null) return;
    final values = [
      awakened,
      awakeMinutes,
      nap,
    ].map((c) => int.tryParse(c.text.trim()) ?? -1).toList();
    if (values.any((value) => value < 0)) {
      setState(() => error = 'Masukkan angka durasi yang valid.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.participants!.saveDiary({
        'sleepDate': _date(date),
        'bedTime': bed.text,
        'sleepStartTime': sleepStart.text,
        'nightAwakenings': values[0],
        'totalAwakeMinutes': values[1],
        'finalWakeTime': finalWake.text,
        'outOfBedTime': outOfBed.text,
        'napMinutes': values[2],
      });
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan tidur berhasil disimpan.')),
        );
    } on ParticipantApiException catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.participants ?? widget.store,
    builder: (context, _) => AppPage(
      title: 'Buku Harian Tidur',
      eyebrow: widget.initialEntry == null ? 'CATAT & KENALI' : 'EDIT CATATAN',
      children: [
        Center(
          child: Image.asset(
            'assets/images/diary.webp',
            width: 140,
            height: 140,
            semanticLabel: 'Ilustrasi buku harian tidur',
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Satu pagi,\nsatu catatan.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 14),
        const Text(
          'Buku harian membantu melihat pola beberapa hari, bukan menilai satu malam. Pengisian dimulai sejak sesi I bersama fasilitator.',
        ),
        const SizedBox(height: 24),
        const InfoBox(
          'Isi satu catatan setiap pagi. Tanggal menunjukkan malam yang dicatat. Catatan ini membantu melihat pola beberapa hari dan bukan penilaian atas satu malam.',
          label: 'Catatan penggunaan',
        ),
        const SizedBox(height: 24),
        if (widget.participants == null ||
            !widget.participants!.registered) ...[
          FilledButton(
            onPressed: () async {
              if (await ensureParticipantAccess(context, widget.participants) &&
                  mounted) {
                await widget.participants?.loadDiary();
                setState(() {});
              }
            },
            child: const Text('Mulai mencatat'),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _webLink,
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Isi Catatan melalui web'),
          ),
          const SizedBox(height: 14),
          const Divider(height: 24),
          const SizedBox(height: 24),
          if (widget.initialEntry != null)
            const InfoBox(
              'Anda sedang mengedit catatan untuk tanggal yang dipilih. Simpan perubahan untuk memperbarui catatan tersebut.',
              label: 'Mode edit',
            ),
          if (widget.initialEntry != null) const SizedBox(height: 14),
          _dateField(context),
          const SizedBox(height: 14),
          _timeField('Jam masuk tempat tidur', bed),
          _timeField('Jam mulai tidur', sleepStart),
          _numberField('Berapa kali terbangun malam?', awakened),
          _numberField('Total lama terjaga (menit)', awakeMinutes),
          _timeField('Jam bangun terakhir', finalWake),
          _timeField('Jam keluar dari tempat tidur', outOfBed),
          _numberField('Durasi tidur siang (menit)', nap),
          if (error != null) ...[
            const SizedBox(height: 14),
            InfoBox(error!, warm: true, label: 'Belum berhasil'),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: saving ? null : _save,
            child: Text(
              saving
                  ? 'Menyimpan…'
                  : widget.initialEntry == null
                  ? 'Simpan catatan'
                  : 'Simpan perubahan',
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Riwayat catatan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (widget.participants!.diaryEntries.isEmpty)
            const InfoBox('Belum ada catatan tidur.'),
          if (widget.participants!.diaryEntries.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => openPage(
                  context,
                  DiaryHistoryPage(participants: widget.participants!),
                ),
                icon: const Icon(Icons.history_rounded),
                label: const Text('Lihat riwayat lengkap'),
              ),
            ),
          for (final entry in widget.participants!.diaryEntries.take(7))
            _historyCard(entry),
        ],
      ],
    ),
  );

  Future<void> _webLink() async {
    try {
      final url = await widget.participants!.createDiaryLink();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Isi melalui web'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Salin atau buka tautan ini pada perangkat yang akan digunakan untuk mengisi buku harian. Tautan berlaku 24 jam.',
                ),
                const SizedBox(height: 16),
                SelectableText(
                  url,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (dialogContext.mounted)
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Tautan berhasil disalin.')),
                  );
              },
              child: const Text('Salin link'),
            ),
            TextButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Buka link'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } on ParticipantApiException catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Widget _dateField(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDate: date,
      );
      if (picked != null) setState(() => date = picked);
    },
    child: InputDecorator(
      decoration: const InputDecoration(labelText: 'Tanggal catatan'),
      child: Text('${_weekday(_date(date))}, ${_date(date)}'),
    ),
  );
  Widget _timeField(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _time(controller),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.schedule_rounded),
      ),
    ),
  );
  Widget _numberField(String label, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            suffixText: label.contains('menit') ? 'menit' : null,
          ),
        ),
      );
  String _weekday(String value) {
    final parsed = DateTime.tryParse(value);
    return parsed == null
        ? value
        : const [
            'Senin',
            'Selasa',
            'Rabu',
            'Kamis',
            'Jumat',
            'Sabtu',
            'Minggu',
          ][parsed.weekday - 1];
  }

  Widget _historyCard(SleepDiaryEntry entry) => Padding(
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
          // Large decorative circle — partially outside the card.
          Positioned(
            top: -42,
            right: -34,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DisqamColors.surfaceAlt.withValues(alpha: 0.85),
              ),
            ),
          ),

          // Small accent circle.
          Positioned(
            top: 22,
            right: 52,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DisqamColors.primary.withValues(alpha: 0.22),
              ),
            ),
          ),

          // Small decorative square.
          Positioned(
            bottom: -9,
            left: 62,
            child: Transform.rotate(
              angle: 0.35,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: DisqamColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),

          // Actual content.
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
            child: Row(
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
                        '${_weekday(entry.sleepDate)}, ${entry.sleepDate}',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          _DiaryMetric(value: entry.bedTime, label: 'masuk'),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                            width: 1,
                            height: 28,
                            color: DisqamColors.border,
                          ),

                          _DiaryMetric(
                            value: entry.outOfBedTime,
                            label: 'keluar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editEntry(entry),
                      icon: const Icon(Icons.edit_outlined, size: 21),
                      tooltip: 'Edit catatan',
                    ),
                    IconButton(
                      onPressed: () => _deleteEntry(entry),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 21,
                        color: Color(0xFFB84B4B),
                      ),
                      tooltip: 'Hapus catatan',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _editEntry(SleepDiaryEntry entry) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DiaryPage(
          store: widget.store,
          participants: widget.participants,
          initialEntry: entry,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _deleteEntry(SleepDiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text(
          'Catatan ${entry.sleepDate} akan dihapus dari buku harian.',
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
      await widget.participants!.deleteDiary(entry.sleepDate);
    } on ParticipantApiException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

class _DiaryMetric extends StatelessWidget {
  const _DiaryMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(color: DisqamColors.navy, fontWeight: FontWeight.w700),
      ),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}
