import 'package:disqam/screens/admin.dart';
import 'package:disqam/services/admin_api.dart';
import 'package:disqam/services/admin_store.dart';
import 'package:disqam/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class ReadyAdminStore extends AdminStore {
  ReadyAdminStore() : super(api: HttpAdminGateway(baseUrl: '')) {
    dashboard = const AdminDashboardData(
      summary: AdminDashboardSummary(
        totalParticipants: 2,
        activeParticipants: 1,
        startedLearning: 1,
        completedLearning: 0,
      ),
      sessionProgress: [],
      diarySummary: AdminDiarySummary(
        totalEntries: 3,
        lastSevenDays: 2,
        activeParticipants: 1,
        note: 'Bukan penilaian klinis.',
      ),
      recentActivity: [],
    );
    participantPage = const AdminParticipantPage(
      items: [],
      page: 1,
      pageSize: 20,
      total: 0,
    );
    diaryParticipantPage = const AdminDiaryParticipantPage(
      items: [],
      page: 1,
      pageSize: 20,
      total: 0,
    );
    analytics = const AdminAnalyticsData(
      summary: AdminAnalyticsSummary(
        totalEntries: 3,
        completeEntries: 2,
        participantsWithDiary: 1,
        averageSleepEfficiency: 82,
        completenessRate: 66.7,
      ),
      participants: [
        AdminParticipantAnalytics(
          code: 'DQ-K72MPABC23',
          initials: 'SR',
          diaryCount: 3,
          completeEntries: 2,
          completenessRate: 66.7,
          averageSleepEfficiency: 82.5,
          averageSleepMinutes: 410.5,
          averageTimeInBedMinutes: 495,
          lastDiaryAt: '2026-09-11T10:00:00.000Z',
        ),
      ],
      note: 'Bukan diagnosis.',
    );
  }

  @override
  bool get authenticated => true;
}

Widget harness(Widget page) => MaterialApp(
  theme: buildDisqamTheme(),
  locale: const Locale('id'),
  supportedLocales: const [Locale('id')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  home: page,
);

void main() {
  testWidgets('admin mobile exposes the same four monitoring areas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(harness(AdminEntryPage(store: ReadyAdminStore())));
    await tester.pumpAndSettle();

    expect(find.text('Pemantauan program'), findsOneWidget);

    await tester.tap(find.text('Peserta').last);
    await tester.pumpAndSettle();
    expect(find.text('Daftar peserta'), findsOneWidget);

    await tester.tap(find.text('Buku Tidur').last);
    await tester.pumpAndSettle();
    expect(find.text('Pemantauan buku harian'), findsOneWidget);

    await tester.tap(find.text('Analitik').last);
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan analitik'), findsOneWidget);
    await tester.drag(
      find.byKey(const PageStorageKey('admin-analytics')),
      const Offset(0, -1400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('DQ-K72MPABC23'));
    await tester.pumpAndSettle();
    expect(find.text('Efisiensi rata-rata'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
