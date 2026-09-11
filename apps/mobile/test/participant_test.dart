import 'package:disqam/content/program.dart';
import 'package:disqam/screens/home.dart';
import 'package:disqam/screens/participant_access.dart';
import 'package:disqam/screens/reading.dart';
import 'package:disqam/services/participant_api.dart';
import 'package:disqam/services/participant_store.dart';
import 'package:disqam/services/reading_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test.dart' show harness, tapVisible;
import 'support.dart';

const testCode = 'DQ-ABCDEFGHJK-ABCDEFGHJKLM';
const testToken = 'abcdefghijklmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUV1';

class MemoryParticipantStorage implements ParticipantStorage {
  final values = <String, String>{};
  @override
  Future<void> delete(String key) async => values.remove(key);
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

class FakeParticipantGateway implements ParticipantGateway {
  String? registrationKey;
  String? loginCode;
  final actions = <String>[];
  bool failWrites = false;
  int registerFailures = 0;
  final states = <String, String>{};

  ParticipantSessionResult get result => ParticipantSessionResult(
    profile: const ParticipantProfile(
      code: 'DQ-ABCDEFGHJK',
      initials: 'AB',
      ageAtEnrollment: 70,
      gender: 'female',
    ),
    token: testToken,
    expiresAt: DateTime.utc(2027),
    accessCode: testCode,
  );

  @override
  Future<ParticipantSessionResult> register({
    required String initials,
    int? age,
    String? gender,
    required String registrationKey,
  }) async {
    this.registrationKey = registrationKey;
    if (registerFailures > 0) {
      registerFailures--;
      throw const ParticipantApiException('Tidak dapat terhubung.');
    }
    return result;
  }

  @override
  Future<ParticipantSessionResult> login(String accessCode) async {
    loginCode = accessCode;
    return result;
  }

  @override
  Future<ParticipantProfile> me(String token) async => result.profile;

  List<ProgramSessionProgress> get records => [
    for (final entry in states.entries)
      ProgramSessionProgress(id: entry.key, status: entry.value),
  ];

  @override
  Future<List<ProgramSessionProgress>> progress(String token) async => records;

  @override
  Future<List<ProgramSessionProgress>> recordProgress(
    String token,
    String sessionId,
    String action,
  ) async {
    actions.add('$sessionId:$action');
    if (failWrites) {
      throw const ParticipantApiException('Tidak dapat terhubung.');
    }
    states[sessionId] = action == 'complete'
        ? 'completed'
        : states[sessionId] ?? 'in_progress';
    return records;
  }

  @override
  Future<List<SleepDiaryEntry>> diary(String token) async => const [];

  @override
  Future<SleepDiaryEntry> saveDiary(
    String token,
    Map<String, dynamic> input,
  ) async => SleepDiaryEntry(
    id: 'diary-1',
    sleepDate: input['sleepDate'] as String,
    bedTime: input['bedTime'] as String,
    sleepStartTime: input['sleepStartTime'] as String?,
    nightAwakenings: input['nightAwakenings'] as int?,
    totalAwakeMinutes: input['totalAwakeMinutes'] as int?,
    finalWakeTime: input['finalWakeTime'] as String,
    outOfBedTime: input['outOfBedTime'] as String,
    napMinutes: input['napMinutes'] as int?,
  );

  @override
  Future<String> createDiaryLink(String token) async =>
      'http://localhost:3000/diary?access=test-link';

  @override
  Future<void> deleteDiary(String token, String sleepDate) async {}
}

void main() {
  testWidgets(
    'program asks participant to register and shows saveable access code',
    (tester) async {
      String? clipboardText;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              clipboardText = (call.arguments as Map)['text'] as String?;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      final gateway = FakeParticipantGateway();
      final participants = ParticipantStore(
        api: gateway,
        storage: MemoryParticipantStorage(),
      );
      await tester.pumpWidget(
        harness(
          HomePage(
            store: ReadingStore(preferences: TestPreferences()),
            participants: participants,
          ),
        ),
      );
      await tapVisible(tester, find.text('Jelajahi program'));
      expect(find.text('Mulai perjalanan Anda'), findsOneWidget);
      expect(find.text('Sudah punya kode kepesertaan'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('participant-initials')),
        'ab',
      );
      await tester.enterText(
        find.byKey(const ValueKey('participant-age')),
        '70',
      );
      await tester.tap(find.byKey(const ValueKey('participant-gender')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perempuan').last);
      await tapVisible(tester, find.text('Daftar dan lanjutkan'));
      expect(find.text('Simpan kode Anda'), findsOneWidget);
      expect(find.text(testCode), findsOneWidget);
      expect(find.text('Salin kode'), findsOneWidget);
      expect(find.text('Simpan melalui WhatsApp'), findsOneWidget);
      expect(gateway.registrationKey, hasLength(43));
      await tapVisible(tester, find.text('Salin kode'));
      expect(clipboardText, testCode);
      expect(find.text('Kode berhasil disalin.'), findsOneWidget);
      await tapVisible(tester, find.text('Saya sudah menyimpan kode'));
      // The registration sheet must close before the Program route opens.
      expect(find.byType(ParticipantAccessSheet), findsNothing);
      expect(find.byType(TopicListPage), findsOneWidget);
      expect(find.text('PROGRAM DISQAM'), findsOneWidget);
      expect(find.text('Lihat kode kepesertaan'), findsOneWidget);
    },
  );

  test('registration retry reuses its secret key', () async {
    final gateway = FakeParticipantGateway()..registerFailures = 1;
    final participants = ParticipantStore(
      api: gateway,
      storage: MemoryParticipantStorage(),
    );
    await expectLater(
      participants.register(initials: 'AB', age: 70, gender: 'female'),
      throwsA(isA<ParticipantApiException>()),
    );
    final firstKey = gateway.registrationKey;
    await participants.register(initials: 'AB', age: 70, gender: 'female');
    expect(gateway.registrationKey, firstKey);
    expect(participants.registered, true);
  });

  test('WhatsApp template contains the access code and no profile data', () {
    final message = participantWhatsAppMessage(testCode);
    expect(message, contains(testCode));
    expect(message, contains('HP yang berbeda'));
    expect(message, isNot(contains('70')));
    expect(message, isNot(contains('Perempuan')));
    final uri = participantWhatsAppUri(testCode);
    expect(uri.host, 'wa.me');
    expect(uri.queryParameters['text'], message);
  });

  testWidgets('existing participant can enter access code on another device', (
    tester,
  ) async {
    final gateway = FakeParticipantGateway();
    final participants = ParticipantStore(
      api: gateway,
      storage: MemoryParticipantStorage(),
    );
    await tester.pumpWidget(
      harness(Scaffold(body: ParticipantAccessSheet(store: participants))),
    );
    await tapVisible(tester, find.text('Sudah punya kode kepesertaan'));
    await tester.enterText(
      find.byKey(const ValueKey('participant-code')),
      '  ${testCode.toLowerCase()}  ',
    );
    await tapVisible(tester, find.text('Masuk'));
    expect(gateway.loginCode, testCode);
    expect(participants.registered, true);
  });

  testWidgets('opening and completing a session synchronize separately', (
    tester,
  ) async {
    final gateway = FakeParticipantGateway();
    final participants = ParticipantStore(
      api: gateway,
      storage: MemoryParticipantStorage(),
    );
    await participants.login(testCode);
    await tester.pumpWidget(
      harness(
        ReadingPage(
          article: programGroup.articles.first,
          store: ReadingStore(preferences: TestPreferences()),
          participants: participants,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(gateway.actions, contains('session-1:open'));
    expect(find.text('Sudah selesai membaca?'), findsOneWidget);
    await tapVisible(tester, find.text('Tandai selesai dipelajari'));
    expect(gateway.actions, contains('session-1:complete'));
    expect(find.text('Materi ini selesai dipelajari'), findsOneWidget);
  });

  testWidgets(
    'failed progress remains pending without blocking local material',
    (tester) async {
      final gateway = FakeParticipantGateway();
      final participants = ParticipantStore(
        api: gateway,
        storage: MemoryParticipantStorage(),
      );
      await participants.login(testCode);
      gateway.failWrites = true;
      await tester.pumpWidget(
        harness(
          ReadingPage(
            article: programGroup.articles.last,
            store: ReadingStore(preferences: TestPreferences()),
            participants: participants,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(programGroup.articles.last.sections.first.title),
        findsOneWidget,
      );
      expect(participants.pending('session-6', 'open'), true);
    },
  );

  testWidgets('participant sheet remains usable at 200 percent text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final participants = ParticipantStore(
      api: FakeParticipantGateway(),
      storage: MemoryParticipantStorage(),
    );
    await tester.pumpWidget(
      harness(
        Scaffold(body: ParticipantAccessSheet(store: participants)),
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsWidgets);
  });
}
