import 'package:disqam/services/reading_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  test('introduction and last section survive restart', () async {
    final prefs = TestPreferences();
    final first = ReadingStore(preferences: prefs);
    await first.load();
    expect(first.introduced, false);
    await first.finishIntroduction();
    await Future.wait([
      first.remember('session-1', 1),
      first.remember('session-1', 3),
    ]);
    final restarted = ReadingStore(preferences: prefs);
    await restarted.load();
    expect(restarted.introduced, true);
    expect(restarted.articleId, 'session-1');
    expect(restarted.sectionIndex, 3);
  });

  test(
    'storage failure preserves in-memory reading and allows app use',
    () async {
      final prefs = TestPreferences()..fail = true;
      final store = ReadingStore(preferences: prefs);
      await store.load();
      await store.finishIntroduction();
      await store.remember('session-2', 1);
      expect(store.storageUnavailable, true);
      expect(store.introduced, true);
      expect(store.articleId, 'session-2');
    },
  );

  test('malformed stored progress does not block startup', () async {
    final prefs = TestPreferences()..values['reading_v1'] = '{bad';
    final store = ReadingStore(preferences: prefs);
    await store.load();
    expect(store.articleId, isNull);
    expect(store.storageUnavailable, true);
  });
}
