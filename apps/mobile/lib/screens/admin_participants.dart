import 'dart:async';

import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'admin_components.dart';

class AdminParticipantsPage extends StatefulWidget {
  const AdminParticipantsPage({super.key, required this.store});

  final AdminStore store;

  @override
  State<AdminParticipantsPage> createState() => _AdminParticipantsPageState();
}

class _AdminParticipantsPageState extends State<AdminParticipantsPage> {
  final searchController = TextEditingController();
  Timer? debounce;
  String gender = 'all';
  String progress = 'all';

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> load({int page = 1}) async {
    try {
      await widget.store.loadParticipants(
        page: page,
        search: searchController.text,
        gender: gender,
        progress: progress,
      );
    } catch (_) {}
  }

  void searchChanged(String _) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 350), load);
  }

  Map<String, String> exportFilters() => {
    if (searchController.text.trim().isNotEmpty)
      'search': searchController.text.trim(),
    if (gender != 'all') 'gender': gender,
    if (progress != 'all') 'progress': progress,
  };

  @override
  Widget build(BuildContext context) {
    final data = widget.store.participantPage;
    return RefreshIndicator(
      onRefresh: () => load(page: data?.page ?? 1),
      child: ListView(
        key: const PageStorageKey('admin-participants'),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          AdminSectionHeader(
            eyebrow: 'PESERTA',
            title: 'Daftar peserta',
            subtitle: 'Cari peserta dan lihat identitas samaran serta perkembangan programnya.',
            actions: [
              AdminExportButtons(
                store: widget.store,
                dataset: 'participants',
                label: 'peserta',
                filters: exportFilters,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AdminCard(
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: searchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'Cari kode atau inisial',
                    hintText: 'Contoh: DQ-K72MP',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: gender,
                  decoration: const InputDecoration(labelText: 'Jenis kelamin'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Semua')),
                    DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'female', child: Text('Perempuan')),
                    DropdownMenuItem(
                      value: 'unspecified',
                      child: Text('Tidak disebutkan'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null || value == gender) return;
                    setState(() => gender = value);
                    load();
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: progress,
                  decoration: const InputDecoration(labelText: 'Perkembangan'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Semua')),
                    DropdownMenuItem(
                      value: 'not-started',
                      child: Text('Belum mulai'),
                    ),
                    DropdownMenuItem(
                      value: 'in-progress',
                      child: Text('Sedang berjalan'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Selesai'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null || value == progress) return;
                    setState(() => progress = value);
                    load();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (widget.store.participantsLoading && data == null)
            const AdminLoadingState(rows: 5)
          else if (widget.store.participantsError != null && data == null)
            AdminErrorState(
              message: widget.store.participantsError!,
              onRetry: load,
            )
          else ...[
            if (widget.store.participantsLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            if (data == null || data.items.isEmpty)
              const AdminEmptyState(
                message: 'Belum ada peserta yang sesuai dengan filter.',
                icon: Icons.people_outline_rounded,
              )
            else ...[
              for (final participant in data.items) ...[
                _ParticipantCard(
                  participant: participant,
                  onTap: () => openPage(
                    context,
                    AdminParticipantDetailPage(
                      store: widget.store,
                      participant: participant,
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

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({required this.participant, required this.onTap});

  final AdminParticipant participant;
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
            CircleAvatar(
              backgroundColor: DisqamColors.surfaceAlt,
              foregroundColor: DisqamColors.primary,
              child: const Icon(Icons.person_outline_rounded),
            ),
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
                    '${participant.initials} · ${adminGenderLabel(participant.gender)} · ${participant.age?.toString() ?? 'Usia tidak dicatat'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${participant.completed}/6 sesi selesai',
                    style: const TextStyle(
                      color: DisqamColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Aktivitas terakhir: ${adminDateLabel(participant.lastLearningActivityAt)}',
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

class AdminParticipantDetailPage extends StatefulWidget {
  const AdminParticipantDetailPage({
    super.key,
    required this.store,
    required this.participant,
  });

  final AdminStore store;
  final AdminParticipant participant;

  @override
  State<AdminParticipantDetailPage> createState() =>
      _AdminParticipantDetailPageState();
}

class _AdminParticipantDetailPageState
    extends State<AdminParticipantDetailPage> {
  late Future<AdminParticipantDetail> future;

  @override
  void initState() {
    super.initState();
    future = widget.store.detail(widget.participant.id);
  }

  void retry() {
    setState(() => future = widget.store.detail(widget.participant.id));
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Detail Peserta',
    eyebrow: 'ADMIN · PESERTA',
    subtitle: 'Identitas samaran dan perkembangan enam sesi DISQAM.',
    children: [
      FutureBuilder<AdminParticipantDetail>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AdminLoadingState();
          }
          if (snapshot.hasError || snapshot.data == null) {
            final message = snapshot.error is AdminApiException
                ? (snapshot.error! as AdminApiException).message
                : 'Detail peserta belum dapat dimuat.';
            return AdminErrorState(message: message, onRetry: retry);
          }
          return _ParticipantDetail(detail: snapshot.data!);
        },
      ),
    ],
  );
}

class _ParticipantDetail extends StatelessWidget {
  const _ParticipantDetail({required this.detail});

  final AdminParticipantDetail detail;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      NightSurface(
        moon: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('KODE PESERTA', light: true),
            const SizedBox(height: 10),
            Text(
              detail.participant.code,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'Inisial ${detail.participant.initials} · ${adminGenderLabel(detail.participant.gender)} · ${detail.participant.age?.toString() ?? 'Usia tidak dicatat'}',
              style: const TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${detail.completedSessions}/6 sesi selesai',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            for (final session in detail.sessions) ...[
              _SessionRow(session: session),
              if (session != detail.sessions.last)
                const Divider(height: 26, color: DisqamColors.border),
            ],
          ],
        ),
      ),
    ],
  );
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final AdminSessionProgress session;

  @override
  Widget build(BuildContext context) {
    final completed = session.status == 'completed';
    final inProgress = session.status == 'in_progress';
    final label = completed
        ? 'Selesai'
        : inProgress
        ? 'Sedang berjalan'
        : 'Belum mulai';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          completed
              ? Icons.check_circle_rounded
              : inProgress
              ? Icons.timelapse_rounded
              : Icons.radio_button_unchecked_rounded,
          color: completed || inProgress
              ? DisqamColors.primary
              : DisqamColors.muted,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
