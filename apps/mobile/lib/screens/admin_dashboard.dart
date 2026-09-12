import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'admin_components.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key, required this.store});

  final AdminStore store;

  Future<void> _refresh() async {
    try {
      await store.loadDashboard();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: _refresh,
    child: ListView(
      key: const PageStorageKey('admin-dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const AdminSectionHeader(
          eyebrow: 'DASHBOARD ADMIN',
          title: 'Pemantauan program',
          subtitle:
              'Lihat perkembangan peserta, sesi program, dan catatan tidur.',
        ),
        const SizedBox(height: 24),
        if (store.dashboardLoading && store.dashboard == null)
          const AdminLoadingState()
        else if (store.dashboardError != null && store.dashboard == null)
          AdminErrorState(message: store.dashboardError!, onRetry: _refresh)
        else if (store.dashboard case final dashboard?) ...[
          NightSurface(
            moon: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('PEMANTAUAN PROGRAM', light: true),
                const SizedBox(height: 14),
                Text(
                  '${dashboard.summary.totalParticipants} peserta',
                  style: Theme.of(context).textTheme.displaySmall
                      ?.copyWith(color: Colors.white, fontSize: 34),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pantau perkembangan program dan catatan tidur peserta.',
                  style: TextStyle(color: Color(0xFFD8E9EE), fontSize: 17),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                      label: 'Total peserta',
                      value: '${dashboard.summary.totalParticipants}',
                      note: 'terdaftar',
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: AdminMetricCard(
                      label: 'Peserta aktif',
                      value: '${dashboard.summary.activeParticipants}',
                      note: 'aktif 14 hari terakhir',
                      icon: Icons.monitor_heart_outlined,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: AdminMetricCard(
                      label: 'Mengikuti program',
                      value: '${dashboard.summary.startedLearning}',
                      note: 'setidaknya satu sesi dibuka',
                      icon: Icons.account_tree_outlined,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: AdminMetricCard(
                      label: 'Program selesai',
                      value: '${dashboard.summary.completedLearning}',
                      note: 'enam sesi selesai',
                      icon: Icons.task_alt_rounded,
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
                  'Buku harian tidur',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _SummaryLine(
                  label: 'Total catatan',
                  value: '${dashboard.diarySummary.totalEntries}',
                ),
                _SummaryLine(
                  label: 'Catatan 7 hari terakhir',
                  value: '${dashboard.diarySummary.lastSevenDays}',
                ),
                _SummaryLine(
                  label: 'Peserta aktif mencatat',
                  value: '${dashboard.diarySummary.activeParticipants}',
                ),
                const SizedBox(height: 8),
                Text(
                  dashboard.diarySummary.note,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
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
                const SizedBox(height: 16),
                for (final session in dashboard.sessionProgress) ...[
                  _SessionProgress(session: session),
                  if (session != dashboard.sessionProgress.last)
                    const SizedBox(height: 18),
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
                  'Aktivitas terbaru',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (dashboard.recentActivity.isEmpty)
                  Text(
                    'Belum ada aktivitas peserta.',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  for (final activity in dashboard.recentActivity)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Icon(
                              Icons.circle,
                              size: 8,
                              color: DisqamColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${activity.code} · ${activity.initials}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(activity.event),
                                Text(
                                  adminDateLabel(activity.time),
                                  style: Theme.of(context).textTheme.bodySmall,
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
        ],
      ],
    ),
  );
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    ),
  );
}

class _SessionProgress extends StatelessWidget {
  const _SessionProgress({required this.session});

  final AdminProgramSessionSummary session;

  @override
  Widget build(BuildContext context) {
    final percent = session.total == 0
        ? 0.0
        : (session.completed / session.total).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 34,
              child: Text(
                session.session,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: DisqamColors.primary),
              ),
            ),
            Expanded(
              child: Text(
                session.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text('${(percent * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: DisqamColors.surfaceAlt,
        ),
      ],
    );
  }
}
