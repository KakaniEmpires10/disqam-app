import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({
    super.key,
    this.onStart,
    this.storageUnavailable = false,
  });
  final VoidCallback? onStart;
  final bool storageUnavailable;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Selamat datang di DISQAM',
    isHome: onStart != null,
    showTitle: false,
    children: [
      NightSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('SELAMAT DATANG', light: true),
            const SizedBox(height: 48),
            const Text(
              'Kenali tidur.\nJaga kualitas hidup.',
              style: TextStyle(
                fontSize: 36,
                height: 1.15,
                fontWeight: FontWeight.w700,
                letterSpacing: -.8,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 26),
            Container(width: 42, height: 3, color: const Color(0xFFF3BC58)),
            const SizedBox(height: 20),
            const Text(
              'Panduan tidur untuk lansia dengan penyakit kronis, dilengkapi materi, latihan, dan pemantauan.',
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Color(0xFFD8E9EE),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      Text(
        'Tentang aplikasi ini',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 12),
      const Text(
        'DISQAM adalah media intervensi tanpa obat yang mengadaptasi Cognitive Behavioral Therapy for Insomnia (CBT-I). Program disesuaikan dengan kondisi, kemampuan, dan kebutuhan lansia dengan penyakit kronis.',
      ),
      const SizedBox(height: 18),
      const InfoBox(
        'Aplikasi ini berisi terapi umum dan tidak menggantikan pemeriksaan atau penilaian tenaga kesehatan. Pemeriksaan kondisi kesehatan dan daya ingat tetap diperlukan sebelum program dimulai.',
        label: 'Penting',
      ),
      const SizedBox(height: 20),
      _IntroDetails(
        title: 'Tujuan aplikasi',
        icon: Icons.flag_outlined,
        children: const [
          'Membantu pelaksanaan langkah DISQAM secara terstruktur untuk memperbaiki kualitas tidur.',
          'Membantu memperlambat atau mencegah kerapuhan melalui perbaikan pola tidur.',
          'Membekali lansia dan pendamping dengan langkah terapi yang dapat dipraktikkan.',
          'Menyediakan materi dan lembar kerja yang sesuai dengan kemampuan baca dan daya ingat lansia.',
        ],
      ),
      const SizedBox(height: 12),
      _IntroDetails(
        title: 'Siapa yang dapat mengikuti?',
        icon: Icons.groups_outlined,
        children: const [
          'Lansia berusia 60 tahun atau lebih.',
          'Mengalami keluhan sulit tidur lebih dari satu bulan.',
          'Memiliki satu atau lebih penyakit kronis, misalnya tekanan darah tinggi, diabetes, osteoartritis, penyakit jantung, atau penyakit paru obstruktif kronis (PPOK).',
          'Mengalami tanda pra-kerapuhan atau kerapuhan ringan, seperti mudah lelah, berjalan lebih lambat, atau berkurangnya kegiatan fisik.',
          'Dapat berkomunikasi dan mengikuti petunjuk sederhana, dengan atau tanpa pendamping.',
        ],
      ),
      const SizedBox(height: 12),
      _IntroDetails(
        title: 'Kapan perlu penyesuaian?',
        icon: Icons.health_and_safety_outlined,
        children: const [
          'Risiko jatuh tinggi tanpa pengawasan di rumah.',
          'Gangguan daya ingat berat yang menghambat pemahaman petunjuk.',
          'Riwayat gangguan bipolar atau kondisi kejiwaan yang dapat memburuk akibat pembatasan tidur.',
          'Kondisi medis akut yang belum stabil.',
          'Pengaturan waktu tidur perlu dilakukan bertahap dan dengan pengawasan tenaga kesehatan.',
        ],
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: onStart ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(onStart != null ? 'Mulai' : 'Kembali ke Tentang Aplikasi'),
      ),
      const SizedBox(height: 16),
      Text(
        'Materi tersedia tanpa internet',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: DisqamColors.primary),
      ),
      if (storageUnavailable) ...[
        const SizedBox(height: 16),
        const InfoBox(
          'Pengaturan belum dapat disimpan di perangkat. Materi tetap bisa dibaca.',
          warm: true,
        ),
      ],
    ],
  );
}

class _IntroDetails extends StatelessWidget {
  const _IntroDetails({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<String> children;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: ExpansionTile(
      leading: Icon(icon, color: DisqamColors.primary),
      title: Text(title),
      shape: const Border(),
      collapsedShape: const Border(),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      children: [for (final item in children) PointText(item)],
    ),
  );
}
