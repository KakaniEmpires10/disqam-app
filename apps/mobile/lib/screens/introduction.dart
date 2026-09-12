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
              'Tidur lebih nyaman.\nJalani hari dengan lebih baik.',
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
              'Kenali tidur dan bangun kebiasaan baik bersama DISQAM.',
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
        'Belajar sesuai\nkemampuan Anda.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 12),
      const Text(
        'Kenali tidur melalui materi dan enam sesi panduan. Pelajari secara bertahap bersama fasilitator, sesuai kondisi dan kenyamanan Anda.',
      ),
      const SizedBox(height: 22),
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
      const SizedBox(height: 28),
      const InfoBox(
        'Panduan ini melengkapi pendampingan, bukan menggantikan pemeriksaan tenaga kesehatan. Mintalah bantuan keluarga bila diperlukan.',
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
