import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

class TestPreferences extends Fake implements SharedPreferencesAsync {
  final Map<String, Object> values = {};
  final List<bool> _failure = [false];
  bool get fail => _failure.single;
  set fail(bool value) => _failure[0] = value;

  @override
  Future<bool?> getBool(String key) async {
    if (fail) throw StateError('Storage unavailable');
    return values[key] as bool?;
  }

  @override
  Future<String?> getString(String key) async {
    if (fail) throw StateError('Storage unavailable');
    return values[key] as String?;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    if (fail) throw StateError('Storage unavailable');
    values[key] = value;
  }

  @override
  Future<void> setString(String key, String value) async {
    if (fail) throw StateError('Storage unavailable');
    values[key] = value;
  }
}
