import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdminApiException implements Exception {
  const AdminApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AdminDashboardSummary {
  const AdminDashboardSummary({
    required this.totalParticipants,
    required this.activeParticipants,
    required this.startedLearning,
    required this.completedLearning,
  });

  final int totalParticipants;
  final int activeParticipants;
  final int startedLearning;
  final int completedLearning;

  factory AdminDashboardSummary.fromJson(Map<String, dynamic> json) =>
      AdminDashboardSummary(
        totalParticipants: _integer(json['totalParticipants']),
        activeParticipants: _integer(json['activeParticipants']),
        startedLearning: _integer(json['startedLearning']),
        completedLearning: _integer(json['completedLearning']),
      );
}

class AdminProgramSessionSummary {
  const AdminProgramSessionSummary({
    required this.session,
    required this.title,
    required this.completed,
    required this.opened,
    required this.total,
  });

  final String session;
  final String title;
  final int completed;
  final int opened;
  final int total;

  factory AdminProgramSessionSummary.fromJson(Map<String, dynamic> json) =>
      AdminProgramSessionSummary(
        session: _string(json['session']),
        title: _string(json['title']),
        completed: _integer(json['completed']),
        opened: _integer(json['opened']),
        total: _integer(json['total']),
      );
}

class AdminDiarySummary {
  const AdminDiarySummary({
    required this.totalEntries,
    required this.lastSevenDays,
    required this.activeParticipants,
    required this.note,
  });

  final int totalEntries;
  final int lastSevenDays;
  final int activeParticipants;
  final String note;

  factory AdminDiarySummary.fromJson(Map<String, dynamic> json) =>
      AdminDiarySummary(
        totalEntries: _integer(json['totalEntries']),
        lastSevenDays: _integer(json['lastSevenDays']),
        activeParticipants: _integer(json['activeParticipants']),
        note: _string(json['note']),
      );
}

class AdminRecentActivity {
  const AdminRecentActivity({
    required this.code,
    required this.initials,
    required this.event,
    required this.time,
  });

  final String code;
  final String initials;
  final String event;
  final String time;

  factory AdminRecentActivity.fromJson(Map<String, dynamic> json) =>
      AdminRecentActivity(
        code: _string(json['code']),
        initials: _string(json['initials']),
        event: _string(json['event']),
        time: _string(json['time']),
      );
}

class AdminDashboardData {
  const AdminDashboardData({
    required this.summary,
    required this.sessionProgress,
    required this.diarySummary,
    required this.recentActivity,
  });

  final AdminDashboardSummary summary;
  final List<AdminProgramSessionSummary> sessionProgress;
  final AdminDiarySummary diarySummary;
  final List<AdminRecentActivity> recentActivity;

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) =>
      AdminDashboardData(
        summary: AdminDashboardSummary.fromJson(_map(json['summary'])),
        sessionProgress: _mapList(
          json['sessionProgress'],
          AdminProgramSessionSummary.fromJson,
        ),
        diarySummary: AdminDiarySummary.fromJson(_map(json['diarySummary'])),
        recentActivity: _mapList(
          json['recentActivity'],
          AdminRecentActivity.fromJson,
        ),
      );
}

class AdminParticipant {
  const AdminParticipant({
    required this.id,
    required this.code,
    required this.initials,
    this.age,
    this.gender,
    required this.opened,
    required this.completed,
    this.createdAt,
    this.lastLearningActivityAt,
  });

  final String id;
  final String code;
  final String initials;
  final int? age;
  final String? gender;
  final int opened;
  final int completed;
  final String? createdAt;
  final String? lastLearningActivityAt;

  factory AdminParticipant.fromJson(Map<String, dynamic> json) =>
      AdminParticipant(
        id: _string(json['id']),
        code: _string(json['code']),
        initials: _string(json['initials']),
        age: _nullableInteger(json['ageAtEnrollment']),
        gender: json['gender'] as String?,
        opened: _integer(json['openedSessions']),
        completed: _integer(json['completedSessions']),
        createdAt: json['createdAt'] as String?,
        lastLearningActivityAt: json['lastLearningActivityAt'] as String?,
      );
}

class AdminParticipantPage {
  const AdminParticipantPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  final List<AdminParticipant> items;
  final int page;
  final int pageSize;
  final int total;

  bool get hasPagination => total > pageSize;
  bool get hasPrevious => page > 1;
  bool get hasNext => page * pageSize < total;

  factory AdminParticipantPage.fromJson(Map<String, dynamic> json) =>
      AdminParticipantPage(
        items: _mapList(json['items'], AdminParticipant.fromJson),
        page: _integer(json['page'], fallback: 1),
        pageSize: _integer(json['pageSize'], fallback: 20),
        total: _integer(json['total']),
      );
}

class AdminSessionProgress {
  const AdminSessionProgress({
    required this.id,
    required this.title,
    required this.status,
    this.firstOpenedAt,
    this.lastOpenedAt,
    this.completedAt,
  });

  final String id;
  final String title;
  final String status;
  final String? firstOpenedAt;
  final String? lastOpenedAt;
  final String? completedAt;

  factory AdminSessionProgress.fromJson(Map<String, dynamic> json) =>
      AdminSessionProgress(
        id: _string(json['id']),
        title: _string(json['title']),
        status: _string(json['status']),
        firstOpenedAt: json['firstOpenedAt'] as String?,
        lastOpenedAt: json['lastOpenedAt'] as String?,
        completedAt: json['completedAt'] as String?,
      );
}

class AdminParticipantDetail {
  const AdminParticipantDetail({
    required this.participant,
    required this.sessions,
    required this.completedSessions,
  });

  final AdminParticipant participant;
  final List<AdminSessionProgress> sessions;
  final int completedSessions;
}

class AdminDiaryParticipant {
  const AdminDiaryParticipant({
    required this.id,
    required this.code,
    required this.initials,
    this.age,
    this.gender,
    required this.diaryCount,
    this.lastDiaryAt,
  });

  final String id;
  final String code;
  final String initials;
  final int? age;
  final String? gender;
  final int diaryCount;
  final String? lastDiaryAt;

  factory AdminDiaryParticipant.fromJson(Map<String, dynamic> json) =>
      AdminDiaryParticipant(
        id: _string(json['id']),
        code: _string(json['code']),
        initials: _string(json['initials']),
        age: _nullableInteger(json['ageAtEnrollment']),
        gender: json['gender'] as String?,
        diaryCount: _integer(json['diaryCount']),
        lastDiaryAt: json['lastDiaryAt'] as String?,
      );
}

class AdminDiaryParticipantPage {
  const AdminDiaryParticipantPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  final List<AdminDiaryParticipant> items;
  final int page;
  final int pageSize;
  final int total;

  bool get hasPagination => total > pageSize;
  bool get hasPrevious => page > 1;
  bool get hasNext => page * pageSize < total;

  factory AdminDiaryParticipantPage.fromJson(Map<String, dynamic> json) =>
      AdminDiaryParticipantPage(
        items: _mapList(json['items'], AdminDiaryParticipant.fromJson),
        page: _integer(json['page'], fallback: 1),
        pageSize: _integer(json['pageSize'], fallback: 20),
        total: _integer(json['total']),
      );
}

class AdminDiaryEntry {
  const AdminDiaryEntry({
    required this.sleepDate,
    required this.bedTime,
    this.sleepStartTime,
    this.nightAwakenings,
    this.totalAwakeMinutes,
    required this.finalWakeTime,
    required this.outOfBedTime,
    this.napMinutes,
    required this.updatedAt,
    required this.timeInBedMinutes,
    required this.sleepMinutes,
    this.sleepEfficiency,
    required this.isComplete,
  });

  final String sleepDate;
  final String bedTime;
  final String? sleepStartTime;
  final int? nightAwakenings;
  final int? totalAwakeMinutes;
  final String finalWakeTime;
  final String outOfBedTime;
  final int? napMinutes;
  final String updatedAt;
  final int timeInBedMinutes;
  final int? sleepMinutes;
  final double? sleepEfficiency;
  final bool isComplete;

  factory AdminDiaryEntry.fromJson(Map<String, dynamic> json) =>
      AdminDiaryEntry(
        sleepDate: _string(json['sleepDate']),
        bedTime: _string(json['bedTime']),
        sleepStartTime: json['sleepStartTime'] as String?,
        nightAwakenings: _nullableInteger(json['nightAwakenings']),
        totalAwakeMinutes: _nullableInteger(json['totalAwakeMinutes']),
        finalWakeTime: _string(json['finalWakeTime']),
        outOfBedTime: _string(json['outOfBedTime']),
        napMinutes: _nullableInteger(json['napMinutes']),
        updatedAt: _string(json['updatedAt']),
        timeInBedMinutes: _integer(json['timeInBedMinutes']),
        sleepMinutes: _nullableInteger(json['sleepMinutes']),
        sleepEfficiency: _nullableDouble(json['sleepEfficiency']),
        isComplete: json['isComplete'] == true,
      );
}

class AdminDiaryDetail {
  const AdminDiaryDetail({required this.participant, required this.entries});

  final AdminDiaryParticipant participant;
  final List<AdminDiaryEntry> entries;

  factory AdminDiaryDetail.fromJson(Map<String, dynamic> json) {
    final participant = _map(json['participant']);
    return AdminDiaryDetail(
      participant: AdminDiaryParticipant.fromJson({
        ...participant,
        'id': participant['id'] ?? '',
        'diaryCount': (json['entries'] as List?)?.length ?? 0,
      }),
      entries: _mapList(json['entries'], AdminDiaryEntry.fromJson),
    );
  }
}

class AdminAnalyticsSummary {
  const AdminAnalyticsSummary({
    required this.totalEntries,
    required this.completeEntries,
    required this.participantsWithDiary,
    this.averageSleepEfficiency,
    this.completenessRate,
  });

  final int totalEntries;
  final int completeEntries;
  final int participantsWithDiary;
  final double? averageSleepEfficiency;
  final double? completenessRate;
}

class AdminParticipantAnalytics {
  const AdminParticipantAnalytics({
    required this.code,
    required this.initials,
    required this.diaryCount,
    required this.completeEntries,
    this.completenessRate,
    this.averageSleepEfficiency,
    this.averageSleepMinutes,
    this.averageTimeInBedMinutes,
    this.lastDiaryAt,
  });

  final String code;
  final String initials;
  final int diaryCount;
  final int completeEntries;
  final double? completenessRate;
  final double? averageSleepEfficiency;
  final double? averageSleepMinutes;
  final double? averageTimeInBedMinutes;
  final String? lastDiaryAt;

  factory AdminParticipantAnalytics.fromJson(Map<String, dynamic> json) =>
      AdminParticipantAnalytics(
        code: _string(json['code']),
        initials: _string(json['initials']),
        diaryCount: _integer(json['diaryCount']),
        completeEntries: _integer(json['completeEntries']),
        completenessRate: _nullableDouble(json['completenessRate']),
        averageSleepEfficiency: _nullableDouble(json['averageSleepEfficiency']),
        averageSleepMinutes: _nullableDouble(json['averageSleepMinutes']),
        averageTimeInBedMinutes: _nullableDouble(
          json['averageTimeInBedMinutes'],
        ),
        lastDiaryAt: json['lastDiaryAt'] as String?,
      );
}

class AdminAnalyticsData {
  const AdminAnalyticsData({
    required this.summary,
    required this.participants,
    required this.note,
  });

  final AdminAnalyticsSummary summary;
  final List<AdminParticipantAnalytics> participants;
  final String note;

  factory AdminAnalyticsData.fromJson(Map<String, dynamic> json) {
    final summary = _map(json['summary']);
    return AdminAnalyticsData(
      summary: AdminAnalyticsSummary(
        totalEntries: _integer(summary['totalEntries']),
        completeEntries: _integer(summary['completeEntries']),
        participantsWithDiary: _integer(summary['participantsWithDiary']),
        averageSleepEfficiency: _nullableDouble(
          summary['averageSleepEfficiency'],
        ),
        completenessRate: _nullableDouble(summary['completenessRate']),
      ),
      participants: _mapList(
        json['participants'],
        AdminParticipantAnalytics.fromJson,
      ),
      note: _string(json['note']),
    );
  }
}

class AdminExportFile {
  const AdminExportFile({
    required this.bytes,
    required this.filename,
    required this.mimeType,
  });

  final Uint8List bytes;
  final String filename;
  final String mimeType;
}

abstract interface class AdminGateway {
  Future<String> login(String email, String password);
  Future<void> logout(String token);
  Future<AdminDashboardData> dashboard(String token);
  Future<AdminParticipantPage> participants(
    String token, {
    int page = 1,
    String search = '',
    String gender = 'all',
    String progress = 'all',
  });
  Future<AdminParticipantDetail> detail(String token, String participantId);
  Future<AdminDiaryParticipantPage> diaryParticipants(
    String token, {
    int page = 1,
    String search = '',
  });
  Future<AdminDiaryDetail> diaryDetail(
    String token,
    String code, {
    String? from,
    String? to,
  });
  Future<AdminAnalyticsData> analytics(String token);
  Future<AdminExportFile> exportData(
    String token, {
    required String dataset,
    required String format,
    Map<String, String> filters = const {},
  });
}

class HttpAdminGateway implements AdminGateway {
  HttpAdminGateway({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String> query = const {}]) {
    final base = Uri.tryParse(baseUrl);
    if (base == null ||
        !base.hasScheme ||
        base.host.isEmpty ||
        (kReleaseMode && base.scheme != 'https')) {
      throw const AdminApiException(
        'Layanan admin belum dikonfigurasi dengan benar.',
      );
    }
    final resolved = base.resolve(path);
    return query.isEmpty ? resolved : resolved.replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    String method = 'GET',
    String? token,
    Object? body,
    Map<String, String> query = const {},
  }) async {
    try {
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';
      if (body != null) headers['Content-Type'] = 'application/json';
      final response =
          await (method == 'POST'
                  ? _client.post(
                      _uri(path, query),
                      headers: headers,
                      body: jsonEncode(body),
                    )
                  : _client.get(_uri(path, query), headers: headers))
              .timeout(const Duration(seconds: 15));
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) throw const FormatException();
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded['success'] != true) {
        throw AdminApiException(
          decoded['message'] is String
              ? decoded['message'] as String
              : 'Permintaan belum berhasil.',
          statusCode: response.statusCode,
        );
      }
      return _map(decoded['data']);
    } on AdminApiException {
      rethrow;
    } catch (_) {
      throw const AdminApiException(
        'Tidak dapat terhubung. Periksa koneksi lalu coba lagi.',
      );
    }
  }

  @override
  Future<String> login(String email, String password) async {
    final data = await _request(
      '/api/admin/auth/token',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
    final token = data['accessToken'];
    if (token is! String || token.isEmpty) {
      throw const AdminApiException('Respons login tidak valid.');
    }
    return token;
  }

  @override
  Future<void> logout(String token) async {
    await _request('/api/admin/auth/logout', method: 'POST', token: token);
  }

  @override
  Future<AdminDashboardData> dashboard(String token) async =>
      AdminDashboardData.fromJson(
        await _request('/api/admin/dashboard', token: token),
      );

  @override
  Future<AdminParticipantPage> participants(
    String token, {
    int page = 1,
    String search = '',
    String gender = 'all',
    String progress = 'all',
  }) async => AdminParticipantPage.fromJson(
    await _request(
      '/api/admin/participants',
      token: token,
      query: {
        'page': '$page',
        if (search.trim().isNotEmpty) 'search': search.trim(),
        if (gender != 'all') 'gender': gender,
        if (progress != 'all') 'progress': progress,
      },
    ),
  );

  @override
  Future<AdminParticipantDetail> detail(
    String token,
    String participantId,
  ) async {
    final data = await _request(
      '/api/admin/participants/detail',
      method: 'POST',
      token: token,
      body: {'participantId': participantId},
    );
    final progress = _map(data['progress']);
    return AdminParticipantDetail(
      participant: AdminParticipant.fromJson(_map(data['participant'])),
      sessions: _mapList(progress['sessions'], AdminSessionProgress.fromJson),
      completedSessions: _integer(progress['completedSessions']),
    );
  }

  @override
  Future<AdminDiaryParticipantPage> diaryParticipants(
    String token, {
    int page = 1,
    String search = '',
  }) async => AdminDiaryParticipantPage.fromJson(
    await _request(
      '/api/admin/diary/participants',
      token: token,
      query: {
        'page': '$page',
        if (search.trim().isNotEmpty) 'search': search.trim(),
      },
    ),
  );

  @override
  Future<AdminDiaryDetail> diaryDetail(
    String token,
    String code, {
    String? from,
    String? to,
  }) async => AdminDiaryDetail.fromJson(
    await _request(
      '/api/admin/diary/${Uri.encodeComponent(code)}',
      token: token,
      query: {
        if (from != null && from.isNotEmpty) 'from': from,
        if (to != null && to.isNotEmpty) 'to': to,
      },
    ),
  );

  @override
  Future<AdminAnalyticsData> analytics(String token) async =>
      AdminAnalyticsData.fromJson(
        await _request('/api/admin/analytics', token: token),
      );

  @override
  Future<AdminExportFile> exportData(
    String token, {
    required String dataset,
    required String format,
    Map<String, String> filters = const {},
  }) async {
    try {
      final response = await _client
          .get(
            _uri('/api/admin/export', {
              'dataset': dataset,
              'format': format,
              ...filters,
            }),
            headers: {'Accept': '*/*', 'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        String message = 'Data belum berhasil diekspor.';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic> && decoded['message'] is String) {
            message = decoded['message'] as String;
          }
        } catch (_) {}
        throw AdminApiException(message, statusCode: response.statusCode);
      }
      final disposition = response.headers['content-disposition'] ?? '';
      final match = RegExp(r'filename="?([^";]+)').firstMatch(disposition);
      return AdminExportFile(
        bytes: response.bodyBytes,
        filename: match?.group(1) ?? 'disqam-$dataset.$format',
        mimeType:
            response.headers['content-type'] ??
            (format == 'xlsx'
                ? 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                : 'text/csv'),
      );
    } on AdminApiException {
      rethrow;
    } catch (_) {
      throw const AdminApiException(
        'Tidak dapat mengunduh data. Periksa koneksi lalu coba lagi.',
      );
    }
  }
}

int _integer(Object? value, {int fallback = 0}) =>
    value is num ? value.toInt() : fallback;

int? _nullableInteger(Object? value) => value is num ? value.toInt() : null;

double? _nullableDouble(Object? value) =>
    value is num ? value.toDouble() : null;

String _string(Object? value) => value is String ? value : '';

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const FormatException('Respons data tidak valid.');
}

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic>) convert) {
  if (value is! List) {
    throw const FormatException('Respons daftar tidak valid.');
  }
  return value
      .whereType<Map<String, dynamic>>()
      .map(convert)
      .toList(growable: false);
}
