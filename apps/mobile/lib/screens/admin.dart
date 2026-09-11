import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AdminEntryPage extends StatefulWidget {
  const AdminEntryPage({super.key, this.store});
  final AdminStore? store;
  @override
  State<AdminEntryPage> createState() => _AdminEntryPageState();
}

class _AdminEntryPageState extends State<AdminEntryPage> {
  late final AdminStore store =
      widget.store ?? AdminStore(api: HttpAdminGateway(baseUrl: ''));
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => store.authenticated
        ? AdminDashboard(store: store)
        : AppPage(
            title: 'Login Admin',
            eyebrow: 'ADMIN',
            subtitle: 'Pantau perkembangan peserta secara aman.',
            children: [
              if (store.error != null)
                InfoBox(store.error!, warm: true, label: 'Belum berhasil'),
              const SizedBox(height: 18),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email admin'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata sandi'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: store.loading
                    ? null
                    : () async {
                        try {
                          await store.login(email.text, password.text);
                        } catch (_) {}
                      },
                child: Text(store.loading ? 'Memeriksa…' : 'Masuk'),
              ),
            ],
          ),
  );
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key, required this.store});
  final AdminStore store;
  @override
  Widget build(BuildContext context) {
    final metrics = store.summary;
    return AppPage(
      title: 'Analitik Peserta',
      eyebrow: 'ADMIN',
      subtitle: 'Ringkasan aktivitas belajar yang tercatat.',
      children: [
        NightSurface(
          moon: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('PEMANTAUAN PROGRAM', light: true),
              const SizedBox(height: 14),
              Text(
                '${metrics?.total ?? 0}',
                style: Theme.of(context).textTheme.displaySmall
                    ?.copyWith(color: Colors.white, fontSize: 48),
              ),
              const SizedBox(height: 4),
              const Text(
                'peserta terdaftar',
                style: TextStyle(color: Color(0xFFD8E9EE), fontSize: 17),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Total peserta',
                value: '${metrics?.total ?? 0}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Metric(
                label: 'Mulai belajar',
                value: '${metrics?.started ?? 0}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Metric(
          label: 'Enam materi selesai',
          value: '${metrics?.completed ?? 0}',
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Peserta terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              onPressed: store.loading
                  ? null
                  : () async {
                      try {
                        await store.refresh();
                      } catch (_) {}
                    },
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Muat ulang',
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (store.loading && store.participants.isEmpty)
          const Center(child: CircularProgressIndicator()),
        if (!store.loading && store.participants.isEmpty)
          const InfoBox('Belum ada peserta yang terdaftar.'),
        for (final participant in store.participants)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _openDetail(context, participant),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 48,
                        decoration: BoxDecoration(
                          color: participant.completed == 6
                              ? const Color(0xFF23866B)
                              : DisqamColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${participant.code} · ${participant.initials}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${participant.opened} sesi dibuka · ${participant.completed} selesai',
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
            ),
          ),
        const SizedBox(height: 20),
        FilledButton.tonalIcon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFCE8E8),
            foregroundColor: const Color(0xFFA84A4A),
          ),
          onPressed: store.logout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Keluar dari admin'),
        ),
      ],
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    AdminParticipant participant,
  ) async {
    try {
      final detail = await store.detail(participant.id);
      if (context.mounted) {
        openPage(context, AdminParticipantDetailPage(detail: detail));
      }
    } on AdminApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: DisqamColors.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    ),
  );
}

class AdminParticipantDetailPage extends StatelessWidget {
  const AdminParticipantDetailPage({super.key, required this.detail});
  final AdminParticipantDetail detail;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Detail Peserta',
    eyebrow: 'ADMIN · PESERTA',
    subtitle: 'Ringkasan progres belajar peserta.',
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
              'Inisial ${detail.participant.initials}',
              style: const TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text('Progres enam sesi', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      for (final session in detail.sessions)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: DisqamColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  _statusLabel(session.status),
                  style: TextStyle(
                    color: session.status == 'completed'
                        ? const Color(0xFF23866B)
                        : DisqamColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
  String _statusLabel(String value) => switch (value) {
    'completed' => 'Selesai',
    'in_progress' => 'Dibuka',
    _ => 'Belum mulai',
  };
}

/// Compatibility preview route used by the rendering test; production entry is AdminEntryPage.
class AnalyticsPreviewPage extends StatelessWidget {
  const AnalyticsPreviewPage({super.key});
  @override
  Widget build(BuildContext context) => const AppPage(
    title: 'Analitik Peserta',
    eyebrow: 'ADMIN',
    subtitle: 'Masuk sebagai admin untuk melihat data terbaru.',
    children: [InfoBox('Data analitik hanya tersedia setelah login admin.')],
  );
}
