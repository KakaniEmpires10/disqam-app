import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_export.dart';
import '../services/admin_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/export_action.dart';

class AdminSectionHeader extends StatelessWidget {
  const AdminSectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Eyebrow(eyebrow),
      const SizedBox(height: 8),
      Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      const SizedBox(height: 8),
      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      if (actions.isNotEmpty) ...[
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: actions),
      ],
    ],
  );
}

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
  });

  final String label;
  final String value;
  final String note;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AdminCard(
    color: DisqamColors.surfaceAlt,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: DisqamColors.primary),
          ],
        ),
        const SizedBox(height: 12),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(note, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

class AdminErrorState extends StatelessWidget {
  const AdminErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.cloud_off_rounded,
          size: 38,
          color: DisqamColors.muted,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Coba lagi'),
        ),
      ],
    ),
  );
}

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon, size: 38, color: DisqamColors.muted),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

class AdminLoadingState extends StatelessWidget {
  const AdminLoadingState({super.key, this.rows = 4});

  final int rows;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const LinearProgressIndicator(minHeight: 3),
      const SizedBox(height: 16),
      for (var index = 0; index < rows; index++) ...[
        AdminCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: DisqamColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, color: DisqamColors.surfaceAlt),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: .65,
                      child: Container(
                        height: 12,
                        color: DisqamColors.surfaceAlt,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    ],
  );
}

class AdminExportButtons extends StatefulWidget {
  const AdminExportButtons({
    super.key,
    required this.store,
    required this.dataset,
    this.label = 'data',
    this.filters,
  });

  final AdminStore store;
  final String dataset;
  final String label;
  final Map<String, String> Function()? filters;

  @override
  State<AdminExportButtons> createState() => _AdminExportButtonsState();
}

class _AdminExportButtonsState extends State<AdminExportButtons> {
  String? exporting;

  Future<void> export(String format) async {
    setState(() => exporting = format);
    try {
      final file = await widget.store.exportData(
        dataset: widget.dataset,
        format: format,
        filters: widget.filters?.call() ?? const {},
      );
      if (!mounted) return;
      await chooseExportAction(
        context: context,
        filename: file.filename,
        bytes: file.bytes,
        mimeType: file.mimeType,
        share: () => AdminExportService.share(file),
      );
    } on AdminApiException catch (exception) {
      if (mounted) _showMessage(exception.message);
    } catch (_) {
      if (mounted) _showMessage('File belum dapat dibuka. Coba lagi.');
    } finally {
      if (mounted) setState(() => exporting = null);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
      OutlinedButton.icon(
        onPressed: exporting == null ? () => export('csv') : null,
        icon: exporting == 'csv'
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.description_outlined),
        label: Text('CSV ${widget.label}'),
      ),
      OutlinedButton.icon(
        onPressed: exporting == null ? () => export('xlsx') : null,
        icon: exporting == 'xlsx'
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.table_chart_outlined),
        label: Text('XLSX ${widget.label}'),
      ),
    ],
  );
}

class AdminPagination extends StatelessWidget {
  const AdminPagination({
    super.key,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
  });

  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: hasPrevious ? onPrevious : null,
          child: const Text('Sebelumnya'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          onPressed: hasNext ? onNext : null,
          child: const Text('Berikutnya'),
        ),
      ),
    ],
  );
}

String adminGenderLabel(String? value) => switch (value) {
  'male' => 'Laki-laki',
  'female' => 'Perempuan',
  'unspecified' => 'Tidak disebutkan',
  _ => 'Belum diisi',
};

String adminDateLabel(String? value, {bool dateOnly = false}) {
  if (value == null || value.isEmpty) return 'Belum ada';
  final date = DateTime.tryParse(value)?.toLocal();
  if (date == null) return value;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  final day = '${date.day} ${months[date.month - 1]} ${date.year}';
  if (dateOnly || !value.contains('T')) return day;
  return '$day, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String adminDateQuery(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

String adminMinutesLabel(num? value) =>
    value == null ? '—' : '${value.round()} menit';
