import 'package:flutter/material.dart';

import '../widgets/common.dart';
import '../theme.dart';
import 'admin.dart';
import '../services/admin_store.dart';
import 'introduction.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.admin});
  final AdminStore? admin;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Tentang Aplikasi',
    eyebrow: 'MENGENAL DISQAM',
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: DisqamColors.surfaceAlt,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo.webp',
            width: 180,
            semanticLabel: 'DISQAM',
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Digital Improving Sleep Quality for Aging Management',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 16),
      const Text(
        'DISQAM membantu lansia mempelajari tidur dan mengikuti panduan kebiasaan tidur berdasarkan adaptasi CBT-I. Program dilaksanakan dengan pendampingan fasilitator sesuai kondisi peserta.',
      ),
      const SizedBox(height: 20),
      const InfoBox(
        'Materi disusun berdasarkan modul DISQAM. Panduan ini tidak menggantikan pemeriksaan dan penilaian klinis oleh tenaga kesehatan.',
      ),
      const SizedBox(height: 24),
      Text(
        'Materi tersedia tanpa internet',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 10),
      const Text(
        'Materi dapat dibaca kapan saja, termasuk saat tidak ada koneksi internet. Posisi bacaan disimpan di perangkat ini agar Anda dapat melanjutkan membaca.',
      ),
      const SizedBox(height: 24),
      OutlinedButton(
        onPressed: () => openPage(context, const IntroductionPage()),
        child: const Text('Lihat pengenalan aplikasi'),
      ),
      const SizedBox(height: 16),
      ListenableBuilder(
        listenable: admin ?? _NoopListenable(),
        builder: (context, _) => FilledButton.icon(
          onPressed: admin == null
              ? null
              : () => openPage(context, AdminEntryPage(store: admin!)),
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: Text(
            admin?.authenticated == true ? 'Buka Monitoring' : 'Login Admin',
          ),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        'DISQAM · Versi 0.1.0',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class _NoopListenable extends ChangeNotifier {}
