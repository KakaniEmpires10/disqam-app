import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdminSummary {
  const AdminSummary({
    required this.total,
    required this.started,
    required this.completed,
  });
  final int total;
  final int started;
  final int completed;
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
  });
  final String id, code, initials;
  final int? age;
  final String? gender;
  final int opened, completed;
  factory AdminParticipant.fromJson(Map<String, dynamic> j) => AdminParticipant(
    id: j['id'] as String,
    code: j['code'] as String,
    initials: j['initials'] as String,
    age: j['ageAtEnrollment'] as int?,
    gender: j['gender'] as String?,
    opened: (j['openedSessions'] as num?)?.toInt() ?? 0,
    completed: (j['completedSessions'] as num?)?.toInt() ?? 0,
  );
}

class AdminApiException implements Exception {
  const AdminApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class AdminSessionProgress {
  const AdminSessionProgress({
    required this.id,
    required this.title,
    required this.status,
  });
  final String id, title, status;
}

class AdminParticipantDetail {
  const AdminParticipantDetail({
    required this.participant,
    required this.sessions,
  });
  final AdminParticipant participant;
  final List<AdminSessionProgress> sessions;
}

abstract interface class AdminGateway {
  Future<String> login(String email, String password);
  Future<AdminSummary> summary(String token);
  Future<List<AdminParticipant>> participants(String token);
  Future<AdminParticipantDetail> detail(String token, String participantId);
}

class HttpAdminGateway implements AdminGateway {
  HttpAdminGateway({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();
  final String baseUrl;
  final http.Client _client;
  Uri _uri(String path) {
    final base = Uri.tryParse(baseUrl);
    if (base == null ||
        !base.hasScheme ||
        base.host.isEmpty ||
        (kReleaseMode && base.scheme != 'https')) {
      throw const AdminApiException(
        'Layanan admin belum dikonfigurasi dengan benar.',
      );
    }
    return base.resolve(path);
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    String method = 'GET',
    String? token,
    Object? body,
  }) async {
    try {
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';
      if (body != null) headers['Content-Type'] = 'application/json';
      final response =
          await (method == 'POST'
                  ? _client.post(
                      _uri(path),
                      headers: headers,
                      body: jsonEncode(body),
                    )
                  : _client.get(_uri(path), headers: headers))
              .timeout(const Duration(seconds: 12));
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }
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
      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        throw const FormatException();
      }
      return data;
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
    if (data['accessToken'] is! String) {
      throw const AdminApiException('Respons login tidak valid.');
    }
    return data['accessToken'] as String;
  }

  @override
  Future<AdminSummary> summary(String token) async {
    final d = await _request('/api/admin/participants/summary', token: token);
    return AdminSummary(
      total: (d['totalParticipants'] as num?)?.toInt() ?? 0,
      started: (d['startedLearning'] as num?)?.toInt() ?? 0,
      completed: (d['completedLearning'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<AdminParticipant>> participants(String token) async {
    final d = await _request('/api/admin/participants?page=1', token: token);
    final items = d['items'];
    if (items is! List) {
      throw const AdminApiException('Data peserta tidak valid.');
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdminParticipant.fromJson)
        .toList(growable: false);
  }

  @override
  Future<AdminParticipantDetail> detail(
    String token,
    String participantId,
  ) async {
    final d = await _request(
      '/api/admin/participants/detail',
      method: 'POST',
      token: token,
      body: {'participantId': participantId},
    );
    final p = d['participant'];
    final rows = d['progress'];
    if (p is! Map<String, dynamic> || rows is! Map<String, dynamic>) {
      throw const AdminApiException('Detail peserta tidak valid.');
    }
    final participant = AdminParticipant.fromJson({
      ...p,
      'openedSessions': 0,
      'completedSessions': 0,
    });
    final sessions = rows['sessions'];
    if (sessions is! List) {
      throw const AdminApiException('Progres peserta tidak valid.');
    }
    return AdminParticipantDetail(
      participant: participant,
      sessions: sessions
          .whereType<Map<String, dynamic>>()
          .map(
            (row) => AdminSessionProgress(
              id: row['id'] as String,
              title: row['title'] as String,
              status: row['status'] as String,
            ),
          )
          .toList(growable: false),
    );
  }
}
