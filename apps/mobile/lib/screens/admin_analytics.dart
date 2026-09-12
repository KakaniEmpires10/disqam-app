import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import 'admin_components.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key, required this.store});

  final AdminStore store;

  Future<void> refresh() async {
    try {
      await store.loadAnalytics();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final analytics = store.analytics;
    final dashboard = store.dashboard;
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        key: const PageStorageKey('admin-analytics'),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const AdminSectionHeader(
            eyebrow: 'ANALITIK',
            title: 'Ringkasan analitik',
            subtitle: 'Ringkasan pola pencatatan tidur dan perkembangan program peserta.',
          ),
          const SizedBox(height: 22),
          if (store.analyticsLoading && analytics == null)
            const AdminLoadingState(rows: 5)
          else if (store.analyticsError != null && analytics == null)
            AdminErrorState(message: store.analyticsError!, onRetry: refresh)
          else if (analytics != null) ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth >= 560
                    ? (constraints.maxWidth - 36) / 4
                    : (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: width,
                      child: AdminMetricCard(
                        label: 'Total catatan',
                        value: '${analytics.summary.totalEntries}',
                        note: 'catatan tidur tersimpan',
                        icon: Icons.book_outlined,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: AdminMetricCard(
                        label: 'Peserta mencatat',
                        value: '${analytics.summary.participantsWithDiary}',
                        note: 'setidaknya satu catatan',
                        icon: Icons.people_outline_rounded,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: AdminMetricCard(
                        label: 'Efisiensi rata-rata',
                        value: analytics.summary.averageSleepEfficiency == null
                            ? '—'
                            : '${analytics.summary.averageSleepEfficiency}%',
                        note: 'dari data yang dapat dihitung',
                        icon: Icons.monitor_heart_outlined,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: AdminMetricCard(
                        label: 'Data lengkap',
                        value: analytics.summary.completenessRate == null
                            ? '—'
                            : '${analytics.summary.completenessRate}%',
                        note:
                            '${analytics.summary.completeEntries} catatan lengkap',
                        icon: Icons.fact_check_outlined,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perkembangan enam sesi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unduh data perkembangan sesi untuk dianalisis lebih lanjut.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  AdminExportButtons(
                    store: store,
                    dataset: 'progress',
                    label: 'perkembangan sesi',
                  ),
                  if (dashboard != null) ...[
                    const SizedBox(height: 20),
                    for (final session in dashboard.sessionProgress) ...[
                      _AnalyticsSessionRow(session: session),
                      if (session != dashboard.sessionProgress.last)
                        const SizedBox(height: 18),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Efisiensi per peserta',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    analytics.note,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  AdminExportButtons(
                    store: store,
                    dataset: 'diary',
                    label: 'buku harian',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (analytics.participants.isEmpty)
              const AdminEmptyState(
                message: 'Belum ada data buku harian tidur.',
                icon: Icons.nightlight_outlined,
              )
            else
              for (final participant in analytics.participants) ...[
                _ParticipantAnalyticsCard(participant: participant),
                const SizedBox(height: 10),
              ],
          ],
        ],
      ),
    );
  }
}

class _AnalyticsSessionRow extends StatelessWidget {
  const _AnalyticsSessionRow({required this.session});

  final AdminProgramSessionSummary session;

  @override
  Widget build(BuildContext context) {
    final fraction = session.total == 0
        ? 0.0
        : (session.completed / session.total).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.session,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: DisqamColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(session.title)),
            Text('${session.completed} selesai'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fraction,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: DisqamColors.surfaceAlt,
        ),
      ],
    );
  }
}

class _ParticipantAnalyticsCard extends StatelessWidget {
  const _ParticipantAnalyticsCard({required this.participant});

  final AdminParticipantAnalytics participant;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: ExpansionTile(
      key: PageStorageKey('participant-analytics-${participant.code}'),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(top: 8),
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        participant.code,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        '${participant.initials} · ${participant.diaryCount} catatan',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        _AnalyticsLine(
          label: 'Kelengkapan',
          value: participant.completenessRate == null
              ? '—'
              : '${participant.completenessRate}%',
        ),
        _AnalyticsLine(
          label: 'Efisiensi rata-rata',
          value: participant.averageSleepEfficiency == null
              ? '—'
              : '${participant.averageSleepEfficiency}%',
          strong: true,
        ),
        _AnalyticsLine(
          label: 'Tidur rata-rata',
          value: adminMinutesLabel(participant.averageSleepMinutes),
        ),
        _AnalyticsLine(
          label: 'Waktu di tempat tidur',
          value: adminMinutesLabel(participant.averageTimeInBedMinutes),
        ),
        _AnalyticsLine(
          label: 'Catatan terakhir',
          value: adminDateLabel(participant.lastDiaryAt),
        ),
      ],
    ),
  );
}

class _AnalyticsLine extends StatelessWidget {
  const _AnalyticsLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
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
