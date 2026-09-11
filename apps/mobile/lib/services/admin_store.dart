import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'admin_api.dart';

class AdminStore extends ChangeNotifier {
  AdminStore({required this.api, FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  final AdminGateway api;
  final FlutterSecureStorage _storage;
  String? _token;
  AdminSummary? summary;
  List<AdminParticipant> participants = const [];
  bool loading = false;
  String? error;
  bool get authenticated => _token != null;
  Future<void> load() async {
    _token = await _storage.read(key: 'admin_access_token_v1');
    if (_token != null) await refresh();
  }

  Future<void> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final token = await api.login(email.trim(), password);
      await _storage.write(key: 'admin_access_token_v1', value: token);
      _token = token;
      await refresh();
    } on AdminApiException catch (e) {
      error = e.message;
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final token = _token;
    if (token == null) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final values = await Future.wait([
        api.summary(token),
        api.participants(token),
      ]);
      summary = values[0] as AdminSummary;
      participants = values[1] as List<AdminParticipant>;
    } on AdminApiException catch (e) {
      error = e.message;
      if (e.statusCode == 401) {
        _token = null;
        await _storage.delete(key: 'admin_access_token_v1');
      }
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<AdminParticipantDetail> detail(String participantId) async {
    final token = _token;
    if (token == null) {
      throw const AdminApiException('Sesi admin belum tersedia.');
    }
    try {
      return await api.detail(token, participantId);
    } on AdminApiException catch (e) {
      if (e.statusCode == 401) {
        _token = null;
        await _storage.delete(key: 'admin_access_token_v1');
        notifyListeners();
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    summary = null;
    participants = const [];
    await _storage.delete(key: 'admin_access_token_v1');
    notifyListeners();
  }
}
