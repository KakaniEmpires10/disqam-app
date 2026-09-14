import 'package:disqam/app.dart';
import 'package:disqam/content/catalog.dart';
import 'package:disqam/content/program.dart';
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
    expect(find.text('Kenali tidur.\nJaga kualitas hidup.'), findsOneWidget);
    await tapVisible(tester, find.text('Mulai'));
    expect(
      find.text('Kenali pola tidur,\nbangun kebiasaan baik.'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Konsep Tidur'));
    await tapVisible(tester, find.text('4. Proses Utama Tidur'));
    expect(find.text('Berikutnya'), findsNothing);
    expect(find.text('Sebelumnya'), findsNothing);
    expect(find.text('Dorongan tidur'), findsOneWidget);
    await tester.ensureVisible(find.text('Jam alami tubuh'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(store.sectionIndex, 1);
    expect(find.text('Jam alami tubuh'), findsOneWidget);
    await tapVisible(tester, find.text('Kembali'));
    await tapVisible(tester, find.text('Kembali'));
    await tapVisible(tester, find.text('Lanjutkan membaca'));
    expect(find.text('Jam alami tubuh'), findsOneWidget);
    expect(store.sectionIndex, 1);
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
    expect(find.text('Kenali tidur.\nJaga kualitas hidup.'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    await tapVisible(tester, find.text('Mulai'));
    await tapVisible(tester, find.text('Tentang'));
    await tapVisible(tester, find.text('Lihat pengenalan aplikasi'));
    expect(find.text('Kenali tidur.\nJaga kualitas hidup.'), findsOneWidget);
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
      final intro = find.widgetWithText(
        OutlinedButton,
        'Lihat pengenalan aplikasi',
      );
      final login = find.widgetWithText(FilledButton, 'Login Admin');
      expect(
        tester.getTopLeft(login).dy,
        greaterThan(tester.getBottomLeft(intro).dy),
      );
      expect(find.text('Masuk monitoring melalui web'), findsOneWidget);
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
    expect(ids.where((id) => id.startsWith('session-')).length, 6);
    expect(findArticle('removed-reading-id'), isNull);
  });
}
