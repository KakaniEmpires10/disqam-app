import 'dart:async';

import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'admin_components.dart';

class AdminDiaryPage extends StatefulWidget {
  const AdminDiaryPage({super.key, required this.store});

  final AdminStore store;

  @override
  State<AdminDiaryPage> createState() => _AdminDiaryPageState();
}

class _AdminDiaryPageState extends State<AdminDiaryPage> {
  final searchController = TextEditingController();
  Timer? debounce;
  DateTime? from;
  DateTime? to;

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> load({int page = 1}) async {
    try {
      await widget.store.loadDiaryParticipants(
        page: page,
        search: searchController.text,
      );
    } catch (_) {}
  }

  void searchChanged(String _) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 350), load);
  }

  Future<void> selectDate(bool start) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: start ? from ?? DateTime.now() : to ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: start ? 'Pilih tanggal mulai' : 'Pilih tanggal akhir',
    );
    if (selected == null || !mounted) return;
    if (!start && from != null && selected.isBefore(from!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal akhir tidak boleh sebelum tanggal mulai.'),
        ),
      );
      return;
    }
    setState(() {
      if (start) {
        from = selected;
        if (to != null && to!.isBefore(selected)) to = null;
      } else {
        to = selected;
      }
    });
  }

  Map<String, String> exportFilters() => {
    if (from != null) 'from': adminDateQuery(from!),
    if (to != null) 'to': adminDateQuery(to!),
  };

  @override
  Widget build(BuildContext context) {
    final data = widget.store.diaryParticipantPage;
    return RefreshIndicator(
      onRefresh: () => load(page: data?.page ?? 1),
      child: ListView(
        key: const PageStorageKey('admin-diary'),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          AdminSectionHeader(
            eyebrow: 'BUKU HARIAN TIDUR',
            title: 'Pemantauan buku harian',
            subtitle: 'Pilih peserta untuk melihat catatan tidur dan efisiensi tidurnya berdasarkan tanggal.',
            actions: [
              AdminExportButtons(
                store: widget.store,
                dataset: 'diary',
                label: 'buku harian',
                filters: exportFilters,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: searchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'Cari kode peserta',
                    hintText: 'Contoh: DQ-K72MP',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                _DateFilterButton(
                  label: 'Tanggal mulai',
                  value: from,
                  onPressed: () => selectDate(true),
                  onClear: from == null
                      ? null
                      : () => setState(() => from = null),
                ),
                const SizedBox(height: 10),
                _DateFilterButton(
                  label: 'Tanggal akhir',
                  value: to,
                  onPressed: () => selectDate(false),
                  onClear: to == null ? null : () => setState(() => to = null),
                ),
                const SizedBox(height: 10),
                Text(
                  'Rentang tanggal digunakan saat membuka atau mengekspor catatan.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (widget.store.diaryParticipantsLoading && data == null)
            const AdminLoadingState(rows: 5)
          else if (widget.store.diaryParticipantsError != null && data == null)
            AdminErrorState(
              message: widget.store.diaryParticipantsError!,
              onRetry: load,
            )
          else ...[
            if (widget.store.diaryParticipantsLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            if (data == null || data.items.isEmpty)
              const AdminEmptyState(
                message: 'Belum ada peserta yang sesuai dengan pencarian.',
                icon: Icons.book_outlined,
              )
            else ...[
              for (final participant in data.items) ...[
                _DiaryParticipantCard(
                  participant: participant,
                  onTap: () => openPage(
                    context,
                    AdminDiaryDetailPage(
                      store: widget.store,
                      participant: participant,
                      initialFrom: from,
                      initialTo: to,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                'Menampilkan ${data.items.length} dari ${data.total} peserta',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (data.hasPagination) ...[
                const SizedBox(height: 12),
                AdminPagination(
                  hasPrevious: data.hasPrevious,
                  hasNext: data.hasNext,
                  onPrevious: () => load(page: data.page - 1),
                  onNext: () => load(page: data.page + 1),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.label,
    required this.value,
    required this.onPressed,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPressed;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value == null
                  ? label
                  : '$label: ${adminDateLabel(adminDateQuery(value!))}',
            ),
          ),
        ),
      ),
      if (onClear != null) ...[
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onClear,
          tooltip: 'Hapus $label',
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ],
  );
}

class _DiaryParticipantCard extends StatelessWidget {
  const _DiaryParticipantCard({required this.participant, required this.onTap});

  final AdminDiaryParticipant participant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: DisqamColors.border),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.menu_book_rounded, color: DisqamColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.code,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Inisial ${participant.initials} · ${adminGenderLabel(participant.gender)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text('${participant.diaryCount} catatan tidur'),
                  Text(
                    'Terakhir: ${adminDateLabel(participant.lastDiaryAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: DisqamColors.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

class AdminDiaryDetailPage extends StatefulWidget {
  const AdminDiaryDetailPage({
    super.key,
    required this.store,
    required this.participant,
    this.initialFrom,
    this.initialTo,
  });

  final AdminStore store;
  final AdminDiaryParticipant participant;
  final DateTime? initialFrom;
  final DateTime? initialTo;

  @override
  State<AdminDiaryDetailPage> createState() => _AdminDiaryDetailPageState();
}

class _AdminDiaryDetailPageState extends State<AdminDiaryDetailPage> {
  DateTime? from;
  DateTime? to;
  late Future<AdminDiaryDetail> future;

  @override
  void initState() {
    super.initState();
    from = widget.initialFrom;
    to = widget.initialTo;
    future = fetch();
  }

  Future<AdminDiaryDetail> fetch() => widget.store.diaryDetail(
    widget.participant.code,
    from: from == null ? null : adminDateQuery(from!),
    to: to == null ? null : adminDateQuery(to!),
  );

  void reload() => setState(() => future = fetch());

  Future<void> selectDate(bool start) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: start ? from ?? DateTime.now() : to ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: start ? 'Pilih tanggal mulai' : 'Pilih tanggal akhir',
    );
    if (selected == null || !mounted) return;
    if (!start && from != null && selected.isBefore(from!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal akhir tidak boleh sebelum tanggal mulai.'),
        ),
      );
      return;
    }
    setState(() {
      if (start) {
        from = selected;
        if (to != null && to!.isBefore(selected)) to = null;
      } else {
        to = selected;
      }
      future = fetch();
    });
  }

  Map<String, String> exportFilters() => {
    'code': widget.participant.code,
    if (from != null) 'from': adminDateQuery(from!),
    if (to != null) 'to': adminDateQuery(to!),
  };

  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.participant.code,
    eyebrow: 'ADMIN · DETAIL BUKU HARIAN',
    subtitle:
        'Inisial ${widget.participant.initials}. Catatan ditampilkan menurut tanggal tidur.',
    children: [
      AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateFilterButton(
              label: 'Tanggal mulai',
              value: from,
              onPressed: () => selectDate(true),
              onClear: from == null
                  ? null
                  : () {
                      setState(() => from = null);
                      reload();
                    },
            ),
            const SizedBox(height: 10),
            _DateFilterButton(
              label: 'Tanggal akhir',
              value: to,
              onPressed: () => selectDate(false),
              onClear: to == null
                  ? null
                  : () {
                      setState(() => to = null);
                      reload();
                    },
            ),
            const SizedBox(height: 14),
            AdminExportButtons(
              store: widget.store,
              dataset: 'diary',
              label: widget.participant.code,
              filters: exportFilters,
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      FutureBuilder<AdminDiaryDetail>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AdminLoadingState(rows: 4);
          }
          if (snapshot.hasError || snapshot.data == null) {
            final message = snapshot.error is AdminApiException
                ? (snapshot.error! as AdminApiException).message
                : 'Catatan peserta belum dapat dimuat.';
            return AdminErrorState(message: message, onRetry: reload);
          }
          final detail = snapshot.data!;
          if (detail.entries.isEmpty) {
            return const AdminEmptyState(
              message: 'Belum ada catatan tidur pada rentang tanggal ini.',
              icon: Icons.nightlight_outlined,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${detail.entries.length} catatan ditampilkan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              for (final entry in detail.entries) ...[
                _DiaryEntryCard(entry: entry),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    ],
  );
}

class _DiaryEntryCard extends StatelessWidget {
  const _DiaryEntryCard({required this.entry});

  final AdminDiaryEntry entry;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                adminDateLabel(entry.sleepDate),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: entry.isComplete
                    ? DisqamColors.surfaceAlt
                    : DisqamColors.accentSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                entry.isComplete ? 'Lengkap' : 'Belum lengkap',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _EntryLine(label: 'Masuk tempat tidur', value: entry.bedTime),
        _EntryLine(
          label: 'Mulai tidur',
          value: entry.sleepStartTime ?? 'Tidak diisi',
        ),
        _EntryLine(
          label: 'Terbangun malam',
          value: entry.nightAwakenings == null
              ? 'Tidak diisi'
              : '${entry.nightAwakenings} kali',
        ),
        _EntryLine(
          label: 'Lama terjaga',
          value: adminMinutesLabel(entry.totalAwakeMinutes),
        ),
        _EntryLine(label: 'Bangun terakhir', value: entry.finalWakeTime),
        _EntryLine(
          label: 'Keluar dari tempat tidur',
          value: entry.outOfBedTime,
        ),
        _EntryLine(
          label: 'Tidur siang',
          value: adminMinutesLabel(entry.napMinutes),
        ),
        const Divider(height: 24, color: DisqamColors.border),
        _EntryLine(
          label: 'Total waktu di tempat tidur',
          value: adminMinutesLabel(entry.timeInBedMinutes),
        ),
        _EntryLine(
          label: 'Perkiraan lama tidur',
          value: adminMinutesLabel(entry.sleepMinutes),
        ),
        _EntryLine(
          label: 'Efisiensi tidur',
          value: entry.sleepEfficiency == null
              ? '—'
              : '${entry.sleepEfficiency}%',
          strong: true,
        ),
        const SizedBox(height: 4),
        Text(
          'Diperbarui ${adminDateLabel(entry.updatedAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _EntryLine extends StatelessWidget {
  const _EntryLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: strong
                ? const TextStyle(
                    color: DisqamColors.primary,
                    fontWeight: FontWeight.w700,
                  )
                : null,
          ),
        ),
      ],
    ),
  );
}
