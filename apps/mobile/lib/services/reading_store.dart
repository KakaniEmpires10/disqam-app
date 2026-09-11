import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive reading preferences only, never auth or research records.
class ReadingStore extends ChangeNotifier {
  ReadingStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _preferences;
  bool introduced = false;
  String? articleId;
  int sectionIndex = 0;
  bool storageUnavailable = false;
  Future<void> _pendingWrite = Future<void>.value();

  Future<void> load() async {
    try {
      final values = await Future.wait([
        _preferences.getBool('intro_seen_v1'),
        _preferences.getString('reading_v1'),
      ]).timeout(const Duration(seconds: 4));
      introduced = values[0] == true;
      if (values[1] is String) {
        final data = jsonDecode(values[1]! as String);
        if (data is Map &&
            data['article'] is String &&
            data['section'] is int) {
          articleId = data['article'] as String;
          sectionIndex = (data['section'] as int).clamp(0, 1000);
        }
      }
    } catch (_) {
      storageUnavailable = true;
    }
    notifyListeners();
  }

  Future<void> finishIntroduction() {
    introduced = true;
    notifyListeners();
    return _save(() => _preferences.setBool('intro_seen_v1', true));
  }

  Future<void> remember(String id, int section) {
    articleId = id;
    sectionIndex = section;
    notifyListeners();
    final data = jsonEncode({'article': id, 'section': section});
    return _save(() => _preferences.setString('reading_v1', data));
  }

  Future<void> _save(Future<void> Function() write) {
    // Preserve order when users move quickly between reading sections.
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await write();
      } catch (_) {
        storageUnavailable = true;
        notifyListeners();
      }
    });
    return _pendingWrite;
  }
}
