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
            'assets/images/mark.webp',
            width: 132,
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
      Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: DisqamColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_note_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tim Penulis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          color: DisqamColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DisqamColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120B414D),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _WriterName('Ns. Rahmawati, S.Kep., M.Kep.'),
            const Divider(height: 1, color: DisqamColors.border),
            const _WriterName('Ns. Fikriyanti, MNS'),
            const Divider(height: 1, color: DisqamColors.border),
            const _WriterName('Ns. Khairani, S. Kep., MPH'),
            const Divider(height: 1, color: DisqamColors.border),
            const _WriterName('Ns. Nurhasanah, M.Kep.'),
            const Divider(height: 1, color: DisqamColors.border),
            const _WriterName('Ns. Irfanita Nurhidayah, S.Kep., M.Kep.'),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text(
        'Harapan Program DISQAM',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 10),
      const Text(
        'DISQAM menjadi penghubung antara bukti ilmiah CBT-I dan kebutuhan lansia dengan penyakit kronis. Melalui langkah yang sederhana, bertahap, dan penuh empati, program ini diharapkan membantu memperbaiki kualitas tidur, memperlambat kerapuhan, serta mendukung kualitas hidup dan kemandirian lansia.',
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
      const SizedBox(height: 20),
      ListenableBuilder(
        listenable: admin ?? _NoopListenable(),
        builder: (context, _) => FilledButton.icon(
          onPressed: admin == null
              ? null
              : () => openPage(context, AdminEntryPage(store: admin!)),
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: Text(
            admin?.authenticated == true ? 'Buka Pemantauan' : 'Login Admin',
          ),
        ),
      ),
      const SizedBox(height: 28),
      Column(
        children: [
          const Icon(
            Icons.code_rounded,
            size: 24,
            color: DisqamColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Dikembangkan oleh',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            'Muhammad Alim Kakani',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        'DISQAM · Versi 0.1.0',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class _NoopListenable extends ChangeNotifier {}

class _WriterName extends StatelessWidget {
  const _WriterName(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.person_outline_rounded,
            size: 20,
            color: DisqamColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}
