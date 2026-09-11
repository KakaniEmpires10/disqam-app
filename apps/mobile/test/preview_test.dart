// Optional visual QA artifacts, kept under ignored build/.
// flutter test test/preview_test.dart --dart-define=CAPTURE_PREVIEWS=true
import 'dart:io';
import 'dart:ui' as ui;

import 'package:disqam/content/program.dart';
import 'package:disqam/content/catalog.dart';
import 'package:disqam/screens/about.dart';
import 'package:disqam/screens/calculator.dart';
import 'package:disqam/screens/home.dart';
import 'package:disqam/screens/introduction.dart';
import 'package:disqam/screens/reading.dart';
import 'package:disqam/services/reading_store.dart';
import 'package:disqam/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  testWidgets('capture mobile screens for visual inspection', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = ReadingStore(preferences: TestPreferences());
    final returningStore = ReadingStore(preferences: TestPreferences());
    await returningStore.remember('session-3', 2);
    final sdk =
        Platform.environment['FLUTTER_ROOT'] ??
        const String.fromEnvironment('FLUTTER_SDK');
    await tester.runAsync(() async {
      final fonts = '$sdk/bin/cache/artifacts/material_fonts';
      for (final font in [
        ('Roboto', 'roboto-regular.ttf'),
        ('MaterialIcons', 'materialicons-regular.otf'),
      ]) {
        final bytes = await File('$fonts/${font.$2}').readAsBytes();
        await (FontLoader(
          font.$1,
        )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
      }
    });
    final pages = <String, Widget>{
      'introduction': IntroductionPage(onStart: () {}),
      'home': HomePage(store: store),
      'home-returning': HomePage(store: returningStore),
      'program': TopicListPage(group: programGroup, store: store),
      'learning': TopicListPage(group: sleepGroup, store: store),
      'reading-cover': ReadingPage(
        article: programGroup.articles[1],
        store: store,
      ),
      'reading': ReadingPage(
        article: programGroup.articles[1],
        store: store,
        initialSection: 1,
      ),
      'calculator': const CalculatorPage(),
      'diary': DiaryPage(store: store),
      'about': const AboutPage(),
    };
    for (final entry in pages.entries) {
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(entry.key),
          debugShowCheckedModeBanner: false,
          theme: buildDisqamTheme(),
          locale: const Locale('id'),
          supportedLocales: const [Locale('id')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: RepaintBoundary(key: boundaryKey, child: entry.value),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final context = boundaryKey.currentContext!;
        for (final asset in [
          'logo',
          'sleep',
          'cbt',
          'program',
          'caregiver',
          'mark',
          'diary',
        ]) {
          await precacheImage(AssetImage('assets/images/$asset.webp'), context);
        }
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory('build/previews').create(recursive: true);
        await File('build/previews/${entry.key}.png')
            .writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
      if (entry.key == 'home' ||
          entry.key == 'program' ||
          entry.key == 'about') {
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -650),
        );
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('build/previews/${entry.key}-lower.png')
              .writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
  }, skip: !const bool.fromEnvironment('CAPTURE_PREVIEWS'));
}
