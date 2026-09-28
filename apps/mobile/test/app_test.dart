import 'package:disqam/app.dart';
import 'package:disqam/content/catalog.dart';
import 'package:disqam/content/program.dart';
import 'package:disqam/content/submenu_icons.dart';
import 'package:disqam/screens/about.dart';
import 'package:disqam/screens/admin.dart';
import 'package:disqam/screens/calculator.dart';
import 'package:disqam/screens/home.dart';
import 'package:disqam/screens/introduction.dart';
import 'package:disqam/screens/reading.dart';
import 'package:disqam/services/reading_store.dart';
import 'package:disqam/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

Widget harness(Widget page, {double scale = 1}) => MaterialApp(
  theme: buildDisqamTheme(),
  locale: const Locale('id'),
  supportedLocales: const [Locale('id')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: page,
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first use, reading and resume navigation', (tester) async {
    final store = ReadingStore(preferences: TestPreferences());
    await tester.pumpWidget(
      DisqamApp(store: store, splashDuration: Duration.zero),
    );
    await tester.pumpAndSettle();
    expect(find.text(introductionHeroTitle), findsOneWidget);
    for (final paragraph in introductionOpeningParagraphs) {
      expect(find.text(paragraph), findsOneWidget);
    }
    await tapVisible(tester, find.text('Mulai'));
    expect(
      find.text('Kenali Pola Tidur,\nMulai Kebiasaan Sehat.'),
      findsOneWidget,
    );
    expect(find.text('Pendahuluan'), findsNothing);
    expect(find.bySemanticsLabel('DISQAM'), findsWidgets);
    await tapVisible(tester, find.text('Mulai Program'));
    expect(find.byType(TopicListPage), findsOneWidget);
  });

  testWidgets('introduction preserves the source goals and participant scope', (
    tester,
  ) async {
    await tester.pumpWidget(harness(const IntroductionPage()));
    expect(find.text('Tujuan aplikasi'), findsOneWidget);
    await tapVisible(tester, find.text('Tujuan aplikasi'));
    expect(
      find.text(
        'Menfasilitasi langkah-langkah pelaksanaan DISQAM yang terstruktur untuk memperbaiki kualitas tidur lansia dengan penyakit kronis.',
      ),
      findsOneWidget,
    );
    expect(find.text('Sasaran Peserta'), findsOneWidget);
    await tapVisible(tester, find.text('Sasaran Peserta'));
    expect(
      find.text(
        'Program DISQAM ditujukan bagi lansia dari usia 60 tahun dengan salah satu atau lebih kondisi berikut:',
      ),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Kondisi yang memerlukan penyesuaian'));
    expect(
      find.text(
        'Pada kondisi-kondisi yang tersebut di atas, komponen pembatasan tidur (sleep restriction) sebaiknya dilakukan dengan pengawasan lebih ketat, dilakukan secara bertahap dan sesuai kebutuhan lansia, atau digantikan dengan fokus pada kebiasaan tidur (higiene tidur) dan relaksasi saja',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'diary explains the digital form and requires participant access',
    (tester) async {
      final store = ReadingStore(preferences: TestPreferences());
      await tester.pumpWidget(harness(HomePage(store: store)));
      await tapVisible(tester, find.text('Buku Harian Tidur'));
      expect(find.text('Catatan penggunaan'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
      expect(find.text('Mulai mencatat'), findsOneWidget);
    },
  );

  testWidgets('bibliography opens directly and conclusion follows it', (tester) async {
    final store = ReadingStore(preferences: TestPreferences());
    await tester.pumpWidget(harness(HomePage(store: store)));

    final bibliographyPosition = tester.getTopLeft(find.text('Daftar Pustaka'));
    final conclusionPosition = tester.getTopLeft(
      find.text(conclusionGroup.title),
    );
    expect(conclusionPosition.dy, greaterThan(bibliographyPosition.dy));

    await tapVisible(tester, find.text('Daftar Pustaka'));
    expect(find.byType(TopicListPage), findsNothing);
    expect(find.text('Lampiran 1'), findsNothing);
    expect(find.text('Daftar pustaka'), findsOneWidget);
    expect(find.text('Baca sebelumnya'), findsNothing);
    expect(find.text('Baca selanjutnya'), findsNothing);
    await tapVisible(tester, find.text('Kembali'));

    await tapVisible(tester, find.text(conclusionGroup.title));
    expect(find.byType(TopicListPage), findsNothing);
    expect(find.text('01'), findsNothing);
    expect(find.bySemanticsLabel('Ikon Penutup'), findsOneWidget);
    final icon = find.bySemanticsLabel('Ikon Penutup');
    final iconAlignment = tester.widget<Align>(
      find.ancestor(of: icon, matching: find.byType(Align)).first,
    );
    expect(iconAlignment.alignment, Alignment.centerLeft);
    expect(
      find.text(
        'Keluhan tidur yang kurang baik sering ditemukan dalam pelayanan kepada lansia. Meskipun kurangnya tidur pada usia lanjut dapat disebabkan oleh berbagai faktor. Terapi kognitif dan perilaku telah menjadi pilihan intervensi lini pertama, terlepas dari jenis kesulitan tidur yang dialami.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Aplikasi ini dapat terus disempurnakan berdasarkan pengalaman lapangan dan masukan dari fasilitator maupun peserta program.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('welcome is shown again when the application starts', (
    tester,
  ) async {
    final prefs = TestPreferences()..values['intro_seen_v1'] = true;
    await tester.pumpWidget(
      DisqamApp(
        store: ReadingStore(preferences: prefs),
        splashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(introductionHeroTitle), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    await tapVisible(tester, find.text('Mulai'));
    await tapVisible(tester, find.text('Tentang'));
    await tapVisible(tester, find.text('Lihat pengenalan aplikasi'));
    expect(find.text(introductionHeroTitle), findsOneWidget);
    await tapVisible(tester, find.text('Kembali ke Tentang Aplikasi'));
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  testWidgets('program recommends order but opens session six directly', (
    tester,
  ) async {
    final store = ReadingStore(preferences: TestPreferences());
    await tester.pumpWidget(
      harness(TopicListPage(group: programGroup, store: store)),
    );
    expect(
      find.textContaining('Anda tetap dapat membuka sesi mana pun'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text(programGroup.articles.last.title));
    expect(store.articleId, 'session-6');
    for (final section in programGroup.articles.last.sections) {
      expect(find.text(section.title), findsOneWidget);
    }
    expect(find.text('Berikutnya'), findsNothing);
  });

  testWidgets('home resumes a session inside the program hero', (tester) async {
    final store = ReadingStore(preferences: TestPreferences());
    await store.remember('session-3', 2);
    await tester.pumpWidget(harness(HomePage(store: store)));
    expect(find.text('Lanjutkan sesi'), findsOneWidget);
    expect(find.text('Lanjutkan membaca'), findsNothing);
    await tapVisible(tester, find.text('Lanjutkan sesi'));
    expect(find.byType(ReadingPage), findsOneWidget);
    expect(store.articleId, 'session-3');
    expect(store.sectionIndex, 2);
    await tapVisible(tester, find.text('Kembali'));
    await tapVisible(tester, find.text('Lihat semua sesi'));
    expect(find.byType(TopicListPage), findsOneWidget);
  });

  testWidgets(
    'about groups introduction and admin actions without an access section',
    (tester) async {
      await tester.pumpWidget(harness(const AboutPage()));
      expect(find.text('Akses peneliti'), findsNothing);
      expect(find.textContaining('tanpa masuk'), findsNothing);
      expect(find.text('Tim Kontributor'), findsOneWidget);
      expect(find.text('Ns. Rahmawati, S.Kep., M.Kep.'), findsOneWidget);
      expect(
        find.text('Ns. Irfanita Nurhidayah, S.Kep., M.Kep.'),
        findsOneWidget,
      );
      final intro = find.widgetWithText(
        OutlinedButton,
        'Lihat pengenalan aplikasi',
      );
      final login = find.widgetWithText(FilledButton, 'Login Admin');
      expect(
        tester.getTopLeft(login).dy,
        greaterThan(tester.getBottomLeft(intro).dy),
      );
      expect(find.text('Masuk monitoring melalui web'), findsNothing);
    },
  );

  testWidgets('contents links jump within the complete article', (
    tester,
  ) async {
    final store = ReadingStore(preferences: TestPreferences());
    await tester.pumpWidget(
      harness(ReadingPage(article: sleepGroup.articles[3], store: store)),
    );
    await tapVisible(tester, find.text('Daftar isi'));
    await tapVisible(tester, find.byKey(const ValueKey('reading-jump-1')));
    await tester.pump(const Duration(milliseconds: 400));
    expect(store.sectionIndex, 1);
    expect(find.text('Dorongan tidur'), findsOneWidget);
    await tapVisible(tester, find.text('Kembali ke awal bacaan'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(store.sectionIndex, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading navigation only shows available adjacent material', (
    tester,
  ) async {
    final store = ReadingStore(preferences: TestPreferences());
    await tester.pumpWidget(
      harness(ReadingPage(article: sleepGroup.articles.first, store: store)),
    );

    expect(find.text('Baca sebelumnya'), findsNothing);
    expect(find.text('Baca selanjutnya'), findsOneWidget);
    await tapVisible(tester, find.text('Baca selanjutnya'));
    await tester.pumpAndSettle();

    expect(find.text(sleepGroup.articles[1].title), findsWidgets);
    expect(find.text('Baca sebelumnya'), findsOneWidget);
    expect(find.text('Baca selanjutnya'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      harness(
        ReadingPage(
          key: const ValueKey('last-reading'),
          article: sleepGroup.articles.last,
          store: store,
        ),
      ),
    );
    expect(find.text('Baca sebelumnya'), findsOneWidget);
    expect(find.text('Baca selanjutnya'), findsNothing);
  });

  testWidgets('Flutter splash uses the mini mark', (tester) async {
    await tester.pumpWidget(
      DisqamApp(
        store: ReadingStore(preferences: TestPreferences()),
        splashDuration: const Duration(seconds: 1),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image).first);
    expect((image.image as AssetImage).assetName, 'assets/images/mark.webp');
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets(
    'admin login uses real credentials and does not show sample data',
    (tester) async {
      await tester.pumpWidget(harness(const AboutPage()));
      await tapVisible(tester, find.text('Login Admin'));
      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(fields.every((field) => field.enabled == true), true);
      expect(find.text('Lihat contoh analitik'), findsNothing);
      expect(find.textContaining('DATA CONTOH'), findsNothing);
    },
  );

  testWidgets('calculator explains and validates sleep efficiency inputs', (
    tester,
  ) async {
    await tester.pumpWidget(harness(const CalculatorPage()));
    expect(find.text('Kalkulator Tidur Saya'), findsOneWidget);
    expect(find.byKey(const ValueKey('sleep-onset-latency')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('wake-after-sleep-onset')),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Hitung tidur saya'));
    expect(
      find.text('Pilih jam masuk dan jam keluar tempat tidur.'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Coba contoh'));
    expect(find.text('HASIL PERKIRAAN TIDUR'), findsOneWidget);
    expect(find.text('Cara menghitung dan arti istilah'), findsOneWidget);
  });

  testWidgets('all content and screens render at 200% text on a small phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = ReadingStore(preferences: TestPreferences());
    final returningStore = ReadingStore(preferences: TestPreferences());
    await returningStore.remember('session-3', 2);
    final pages = <Widget>[
      HomePage(store: store),
      HomePage(store: returningStore),
      DiaryPage(store: store),
      const IntroductionPage(),
      const AboutPage(),
      const AdminEntryPage(),
      const AnalyticsPreviewPage(),
      const CalculatorPage(),
      for (final group in contentGroups)
        TopicListPage(group: group, store: store),
      for (final group in contentGroups)
        for (final article in group.articles)
          for (var i = 0; i < article.sections.length; i++)
            ReadingPage(
              key: ValueKey('${article.id}-$i'),
              article: article,
              store: store,
              initialSection: i,
            ),
    ];
    for (final page in pages) {
      await tester.pumpWidget(harness(page, scale: 2));
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Large text: ${page.runtimeType} ${page.key}',
      );
    }
  });

  test('content ids are unique and six program sessions are available', () {
    final ids = contentGroups
        .expand((group) => group.articles)
        .map((article) => article.id)
        .toList();
    expect(ids.toSet().length, ids.length);
    expect(submenuIconAssets.keys.toSet(), ids.toSet());
    expect(ids.where((id) => id.startsWith('session-')).length, 6);
    expect(findArticle('removed-reading-id'), isNull);
  });

  test('single-section materials provide a related icon', () {
    for (final group in contentGroups) {
      if (group.articles.any((article) => article.sections.length == 1)) {
        expect(group.singleSectionIconAsset, isNotNull);
      }
    }
  });

  test('every table in the six program sessions can be exported', () {
    for (final article in programGroup.articles) {
      for (final section in article.sections) {
        for (final table in section.tables) {
          expect(table.exportable, isTrue, reason: table.title);
        }
      }
    }
  });
}
