import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'admin_api.dart';

class AdminStore extends ChangeNotifier {
  AdminStore({required this.api, FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'admin_access_token_v1';

  final AdminGateway api;
  final FlutterSecureStorage _storage;

  String? _token;
  bool loading = false;
  String? error;

  AdminDashboardData? dashboard;
  bool dashboardLoading = false;
  String? dashboardError;

  AdminParticipantPage? participantPage;
  bool participantsLoading = false;
  String? participantsError;

  AdminDiaryParticipantPage? diaryParticipantPage;
  bool diaryParticipantsLoading = false;
  String? diaryParticipantsError;

  AdminAnalyticsData? analytics;
  bool analyticsLoading = false;
  String? analyticsError;

  bool get authenticated => _token != null;

  Future<void> load() async {
    _token = await _storage.read(key: _tokenKey);
    if (_token != null) {
      try {
        await loadDashboard();
      } on AdminApiException {
        // The page presents the retry state. Invalid sessions are cleared below.
      }
    }
  }

  Future<void> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final token = await api.login(email.trim(), password);
      await _storage.write(key: _tokenKey, value: token);
      _token = token;
      await loadDashboard();
    } on AdminApiException catch (exception) {
      error = exception.message;
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadDashboard() async {
    final token = _requireToken();
    dashboardLoading = true;
    dashboardError = null;
    notifyListeners();
    try {
      dashboard = await api.dashboard(token);
    } on AdminApiException catch (exception) {
      dashboardError = exception.message;
      await _handleAuthorizationError(exception);
      rethrow;
    } finally {
      dashboardLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadParticipants({
    int page = 1,
    String search = '',
    String gender = 'all',
    String progress = 'all',
  }) async {
    final token = _requireToken();
    participantsLoading = true;
    participantsError = null;
    notifyListeners();
    try {
      participantPage = await api.participants(
        token,
        page: page,
        search: search,
        gender: gender,
        progress: progress,
      );
    } on AdminApiException catch (exception) {
      participantsError = exception.message;
      await _handleAuthorizationError(exception);
      rethrow;
    } finally {
      participantsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDiaryParticipants({int page = 1, String search = ''}) async {
    final token = _requireToken();
    diaryParticipantsLoading = true;
    diaryParticipantsError = null;
    notifyListeners();
    try {
      diaryParticipantPage = await api.diaryParticipants(
        token,
        page: page,
        search: search,
      );
    } on AdminApiException catch (exception) {
      diaryParticipantsError = exception.message;
      await _handleAuthorizationError(exception);
      rethrow;
    } finally {
      diaryParticipantsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAnalytics() async {
    final token = _requireToken();
    analyticsLoading = true;
    analyticsError = null;
    notifyListeners();
    try {
      final values = await Future.wait<Object>([
        api.analytics(token),
        if (dashboard == null) api.dashboard(token),
      ]);
      analytics = values.first as AdminAnalyticsData;
      if (values.length > 1) dashboard = values[1] as AdminDashboardData;
    } on AdminApiException catch (exception) {
      analyticsError = exception.message;
      await _handleAuthorizationError(exception);
      rethrow;
    } finally {
      analyticsLoading = false;
      notifyListeners();
    }
  }

  Future<AdminParticipantDetail> detail(String participantId) async {
    try {
      return await api.detail(_requireToken(), participantId);
    } on AdminApiException catch (exception) {
      await _handleAuthorizationError(exception);
      rethrow;
    }
  }

  Future<AdminDiaryDetail> diaryDetail(
    String code, {
    String? from,
    String? to,
  }) async {
    try {
      return await api.diaryDetail(_requireToken(), code, from: from, to: to);
    } on AdminApiException catch (exception) {
      await _handleAuthorizationError(exception);
      rethrow;
    }
  }

  Future<AdminExportFile> exportData({
    required String dataset,
    required String format,
    Map<String, String> filters = const {},
  }) async {
    try {
      return await api.exportData(
        _requireToken(),
        dataset: dataset,
        format: format,
        filters: filters,
      );
    } on AdminApiException catch (exception) {
      await _handleAuthorizationError(exception);
      rethrow;
    }
  }

  Future<void> logout() async {
    final token = _token;
    _clearData();
    await _storage.delete(key: _tokenKey);
    notifyListeners();
    if (token != null) {
      try {
        await api.logout(token);
      } on AdminApiException {
        // The local credential is already removed; remote expiry remains bounded.
      }
    }
  }

  String _requireToken() {
    final token = _token;
    if (token == null) {
      throw const AdminApiException('Sesi admin belum tersedia.');
    }
    return token;
  }

  Future<void> _handleAuthorizationError(AdminApiException exception) async {
    if (exception.statusCode != 401) return;
    _clearData();
    await _storage.delete(key: _tokenKey);
    notifyListeners();
  }

  void _clearData() {
    _token = null;
    dashboard = null;
    participantPage = null;
    diaryParticipantPage = null;
    analytics = null;
  }
}
