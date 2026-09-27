import 'package:flutter/material.dart';

import '../widgets/common.dart';

const introductionOpeningParagraphs = [
  'Aplikasi \u201CDigital Improving Sleep Quality for Aging Management (DISQAM)" dibuat sebagai media intervensi non-farmakologis (terapi tanpa obat-obatan) dengan mengadaptasi prinsip-prinsip Cognitive Behavioral Therapy for Insomnia (CBT-I). Pendekatan ini telah direkomendasikan sebagai terapi pilihan utama yang dianjurkan untuk insomnia kronis atau dengan masalah kualitas tidur yang buruk. Terapi ini juga disesuaikan dengan kondisi, kemampuan, serta kebutuhan khusus lansia dengan penyakit kronis.',
];

Future<void> showIntroductionDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const IntroductionDialog(),
);

class IntroductionDialog extends StatelessWidget {
  const IntroductionDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 620,
        maxHeight: MediaQuery.sizeOf(context).height * .78,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/mark.webp',
                width: 132,
                height: 132,
                fit: BoxFit.contain,
                semanticLabel: 'DISQAM',
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final paragraph in introductionOpeningParagraphs) ...[
                      ForeignTermsText(
                        paragraph,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Lanjut Ke Program'),
            ),
          ],
        ),
      ),
    ),
  );
}
