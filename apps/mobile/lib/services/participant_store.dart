// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'participant_api.dart';

abstract interface class ParticipantStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureParticipantStorage implements ParticipantStorage {
  const SecureParticipantStorage([this.storage = const FlutterSecureStorage()]);
  final FlutterSecureStorage storage;
  @override
  Future<String?> read(String key) => storage.read(key: key);
  @override
  Future<void> write(String key, String value) =>
      storage.write(key: key, value: value);
  @override
  Future<void> delete(String key) => storage.delete(key: key);
}

class ParticipantStore extends ChangeNotifier {
  ParticipantStore({required this.api, ParticipantStorage? storage})
    : storage = storage ?? const SecureParticipantStorage();
  final ParticipantGateway api;
  final ParticipantStorage storage;
  ParticipantProfile? profile;
  String? accessCode;
  String? _token;
  DateTime? expiresAt;
  List<ProgramSessionProgress> progress = const [];
  List<SleepDiaryEntry> diaryEntries = const [];
  Set<String> pendingActions = {};
  bool loading = false;
  String? lastError;
  Future<void> _syncTail = Future<void>.value();
  bool get registered => _token != null && profile != null;

  static const _sessionKey = 'participant_session_v1';
  static const _pendingRegistrationKey = 'participant_registration_v1';
  static const _pendingProgressKey = 'participant_progress_pending_v1';

  Future<void> load() async {
    try {
      final raw = await storage.read(_sessionKey);
      if (raw != null) {
        final value = jsonDecode(raw);
        if (value is Map<String, dynamic> &&
            value['token'] is String &&
            value['profile'] is Map<String, dynamic>) {
          _token = value['token'] as String;
          profile = ParticipantProfile.fromJson(
            value['profile'] as Map<String, dynamic>,
          );
          accessCode = value['accessCode'] as String?;
          expiresAt = DateTime.tryParse(value['expiresAt'] as String? ?? '');
        }
      }
      final pending = await storage.read(_pendingProgressKey);
      if (pending != null) {
        pendingActions = (jsonDecode(pending) as List)
            .whereType<String>()
            .toSet();
      }
      if (registered) {
        await sync().timeout(const Duration(seconds: 5));
      }
    } on ParticipantApiException catch (error) {
      if (error.statusCode == 401) {
        await _clearSession();
      }
      lastError = error.message;
    } catch (_) {
      lastError = 'Data peserta belum dapat diperiksa. Anda tetap dapat membaca materi.';
    }
    notifyListeners();
  }

  String _newKey() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  Future<ParticipantSessionResult> register({
    required String initials,
    int? age,
    String? gender,
  }) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      final desired = {
        'initials': initials.trim().toUpperCase(),
        'age': age,
        'gender': gender,
      };
      final rawPending = await storage.read(_pendingRegistrationKey);
      var registrationKey = _newKey();
      if (rawPending != null) {
        final pending = jsonDecode(rawPending);
        if (pending is Map<String, dynamic> &&
            pending['profile'].toString() == jsonEncode(desired) &&
            pending['key'] is String) {
          registrationKey = pending['key'] as String;
        }
      }
      await storage.write(
        _pendingRegistrationKey,
        jsonEncode({'profile': jsonEncode(desired), 'key': registrationKey}),
      );
      final result = await api.register(
        initials: initials,
        age: age,
        gender: gender,
        registrationKey: registrationKey,
      );
      await _saveSession(result);
      await storage.delete(_pendingRegistrationKey);
      return result;
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<ParticipantSessionResult> login(String code) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      final normalizedCode = code
          .trim()
          .toUpperCase()
          .replaceAll(RegExp('[\u2013\u2014\u2212]'), '-')
          .replaceAll(RegExp(r'\s+'), '');
      final result = await api.login(normalizedCode);
      await _saveSession(result);
      try {
        await sync();
      } on ParticipantApiException catch (error) {
        if (error.statusCode == 401) {
          await _clearSession();
          rethrow;
        }
        lastError = error.message;
      }
      return result;
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _saveSession(ParticipantSessionResult result) async {
    final nextCode = result.accessCode ?? accessCode;
    await storage.write(
      _sessionKey,
      jsonEncode({
        'token': result.token,
        'accessCode': nextCode,
        'expiresAt': result.expiresAt.toIso8601String(),
        'profile': result.profile.toJson(),
      }),
    );
    profile = result.profile;
    _token = result.token;
    accessCode = nextCode;
    expiresAt = result.expiresAt;
  }

  Future<void> sync() {
    final operation = _syncTail.then(
      (_) => _syncNow(),
      onError: (_) => _syncNow(),
    );
    _syncTail = operation;
    return operation;
  }

  Future<void> _syncNow() async {
    final token = _token;
    if (token == null) {
      return;
    }
    final remoteProfile = await api.me(token);
    profile = remoteProfile;
    for (final action in pendingActions.toList()) {
      final parts = action.split(':');
      progress = await api.recordProgress(token, parts[0], parts[1]);
      pendingActions.remove(action);
      await _savePending();
    }
    progress = await api.progress(token);
    lastError = null;
    notifyListeners();
  }

  Future<void> loadDiary() async {
    final token = _token;
    if (token == null) return;
    try {
      diaryEntries = await api.diary(token);
      notifyListeners();
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      if (error.statusCode == 401) await _clearSession();
      notifyListeners();
    }
  }

  Future<SleepDiaryEntry> saveDiary(Map<String, dynamic> input) async {
    final token = _token;
    if (token == null)
      throw const ParticipantApiException(
        'Buka akses peserta terlebih dahulu.',
      );
    try {
      final entry = await api.saveDiary(token, input);
      diaryEntries = [
        entry,
        ...diaryEntries.where((item) => item.sleepDate != entry.sleepDate),
      ];
      lastError = null;
      notifyListeners();
      return entry;
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      if (error.statusCode == 401) await _clearSession();
      notifyListeners();
      rethrow;
    }
  }

  Future<String> createDiaryLink() async {
    final token = _token;
    if (token == null)
      throw const ParticipantApiException(
        'Buka akses peserta terlebih dahulu.',
      );
    return api.createDiaryLink(token);
  }

  Future<void> deleteDiary(String sleepDate) async {
    final token = _token;
    if (token == null)
      throw const ParticipantApiException(
        'Buka akses peserta terlebih dahulu.',
      );
    try {
      await api.deleteDiary(token, sleepDate);
      diaryEntries = diaryEntries
          .where((entry) => entry.sleepDate != sleepDate)
          .toList(growable: false);
      notifyListeners();
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      notifyListeners();
      rethrow;
    }
  }

  Future<ParticipantExportFile> exportDiary({
    required String from,
    required String to,
  }) async {
    final token = _token;
    if (token == null) {
      throw const ParticipantApiException(
        'Buka akses peserta terlebih dahulu.',
      );
    }
    try {
      return await api.exportDiary(token, from: from, to: to);
    } on ParticipantApiException catch (error) {
      lastError = error.message;
      if (error.statusCode == 401) await _clearSession();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> record(String sessionId, String action) async {
    if (!registered) {
      return false;
    }
    try {
      final key = '$sessionId:$action';
      pendingActions.add(key);
      await _savePending();
      notifyListeners();
      await sync();
      return true;
    } on ParticipantApiException catch (error) {
      if (error.statusCode == 401) {
        await _clearSession();
      }
      lastError = error.message;
      notifyListeners();
      return false;
    } catch (_) {
      lastError =
          'Perkembangan sesi tersimpan sementara dan akan dicoba kembali.';
      notifyListeners();
      return false;
    }
  }

  ProgramSessionProgress? session(String id) {
    for (final item in progress) {
      if (item.id == id) return item;
    }
    return null;
  }

  bool pending(String id, String action) =>
      pendingActions.contains('$id:$action');

  Future<void> _savePending() async {
    if (pendingActions.isEmpty) {
      await storage.delete(_pendingProgressKey);
    } else {
      await storage.write(
        _pendingProgressKey,
        jsonEncode(pendingActions.toList()),
      );
    }
  }

  Future<void> _clearSession() async {
    _token = null;
    profile = null;
    accessCode = null;
    expiresAt = null;
    progress = const [];
    diaryEntries = const [];
    pendingActions.clear();
    await storage.delete(_sessionKey);
    await storage.delete(_pendingProgressKey);
  }
}
