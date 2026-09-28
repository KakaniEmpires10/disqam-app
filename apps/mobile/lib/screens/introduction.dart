import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

const introductionHeroTitle = 'Tidur Tenang.\nSambut Hari dengan Senang.';
const introductionHeroDescription =
    'DISQAM menemani langkah kecil Anda membangun kebiasaan tidur sehat, malam demi malam.';
const introductionOpeningParagraphs = [
  'Aplikasi “Digital Improving Sleep Quality for Aging Management (DISQAM)” dibuat sebagai media intervensi non-farmakologis (terapi tanpa obat-obatan) dengan mengadaptasi prinsip-prinsip Cognitive Behavioral Therapy for Insomnia (CBT-I). Pendekatan ini telah direkomendasikan sebagai terapi pilihan utama yang dianjurkan untuk insomnia kronis atau dengan masalah kualitas tidur yang buruk. Terapi ini juga disesuaikan dengan kondisi, kemampuan, serta kebutuhan khusus lansia dengan penyakit kronis.',
];

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
            const Eyebrow('SELAMAT DATANG DI PROGRAM DISQAM', light: true),
            const SizedBox(height: 48),
            const Text(
              introductionHeroTitle,
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
              introductionHeroDescription,
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
      for (final paragraph in introductionOpeningParagraphs)
        ForeignTermsText(paragraph, textAlign: TextAlign.justify),
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
          'Menfasilitasi langkah-langkah pelaksanaan DISQAM yang terstruktur untuk memperbaiki kualitas tidur lansia dengan penyakit kronis.',
          'Membantu memperlambat atau mencegah perkembangan frailty (kerapuhan) melalui perbaikan pola tidur.',
          'Membekali lansia dan pendamping (tenaga kesehatan/kader) dengan langkah-langkah (sesi) terapi yang aplikatif.',
          'Menyediakan materi dan lembar kerja siap pakai yang sesuai dengan kemampuan baca dan dan kemampuan daya ingat lansia.',
        ],
      ),
      const SizedBox(height: 12),
      _IntroDetails(
        title: 'Sasaran Peserta',
        icon: Icons.groups_outlined,
        introduction: 'Program DISQAM ditujukan bagi lansia dari usia 60 tahun dengan salah satu atau lebih kondisi berikut:',
        children: const [
          'Mengalami keluhan sulit tidur yang berlangsung lebih dari 1 bulan.',
          'Memiliki satu atau lebih penyakit kronis (misalnya hipertensi, diabetes melitus, osteoartritis, penyakit jantung, penyakit Paru Obstruktif Kronis (PPOK)).',
          'Menunjukkan tanda-tanda pra-frailty atau frailty ringan (mudah lelah, penurunan kecepatan berjalan, penurunan aktivitas fisik).',
          'Mampu berkomunikasi dan mengikuti instruksi sederhana (dengan atau tanpa bantuan keluarga atau pendamping).',
        ],
      ),
      const SizedBox(height: 12),
      _IntroDetails(
        title: 'Kondisi yang memerlukan penyesuaian',
        icon: Icons.health_and_safety_outlined,
        callout: 'Beberapa kondisi berikut memerlukan penyesuaian program atau rujukan lebih lanjut sebelum memulai DISQAM, terutama komponen pembatasan tidur:',
        children: const [
          'Risiko jatuh tinggi tanpa pengawasan/pendamping di rumah.',
          'Gangguan kognitif berat (demensia sedang dan berat) yang menghambat pemahaman instruksi.',
          'Riwayat gangguan bipolar atau kondisi kejiwaan yang dapat memburuk akibat pembatasan tidur.',
          'Kondisi medis akut yang belum stabil (masalah kesehatannya perlu ditangani terlebih dahulu sebelum mengikuti kegiatan.).',
        ],
        closingCallout: 'Pada kondisi-kondisi yang tersebut di atas, komponen pembatasan tidur (sleep restriction) sebaiknya dilakukan dengan pengawasan lebih ketat, dilakukan secara bertahap dan sesuai kebutuhan lansia, atau digantikan dengan fokus pada kebiasaan tidur (higiene tidur) dan relaksasi saja',
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
    this.introduction,
    this.callout,
    this.closingCallout,
  });

  final String title;
  final IconData icon;
  final List<String> children;
  final String? introduction, callout, closingCallout;

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
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      children: [
        if (introduction != null) ...[
          ForeignTermsText(introduction!),
          const SizedBox(height: 12),
        ],
        if (callout != null) ...[
          ForeignTermsText(callout!),
          const SizedBox(height: 12),
        ],
        for (final item in children) PointText(item),
        if (closingCallout != null) ...[
          const SizedBox(height: 12),
          InfoBox(closingCallout!),
        ],
      ],
    ),
  );
}
