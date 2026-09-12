// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ParticipantProfile {
  const ParticipantProfile({
    required this.code,
    required this.initials,
    this.ageAtEnrollment,
    this.gender,
  });
  final String code;
  final String initials;
  final int? ageAtEnrollment;
  final String? gender;

  factory ParticipantProfile.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final initials = json['initials'];
    if (code is! String || initials is! String) {
      throw const FormatException('Invalid participant profile');
    }
    return ParticipantProfile(
      code: code,
      initials: initials,
      ageAtEnrollment: json['ageAtEnrollment'] as int?,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'initials': initials,
    'ageAtEnrollment': ageAtEnrollment,
    'gender': gender,
  };
}

class ProgramSessionProgress {
  const ProgramSessionProgress({required this.id, required this.status});
  final String id;
  final String status;
  bool get completed => status == 'completed';
}

class SleepDiaryEntry {
  const SleepDiaryEntry({
    required this.id,
    required this.sleepDate,
    required this.bedTime,
    this.sleepStartTime,
    this.nightAwakenings,
    this.totalAwakeMinutes,
    required this.finalWakeTime,
    required this.outOfBedTime,
    this.napMinutes,
  });
  final String id, sleepDate, bedTime, finalWakeTime, outOfBedTime;
  final String? sleepStartTime;
  final int? nightAwakenings, totalAwakeMinutes, napMinutes;
  factory SleepDiaryEntry.fromJson(Map<String, dynamic> json) =>
      SleepDiaryEntry(
        id: json['id'] as String,
        sleepDate: json['sleepDate'] as String,
        bedTime: json['bedTime'] as String,
        sleepStartTime: json['sleepStartTime'] as String?,
        nightAwakenings: (json['nightAwakenings'] as num?)?.toInt(),
        totalAwakeMinutes: (json['totalAwakeMinutes'] as num?)?.toInt(),
        finalWakeTime: json['finalWakeTime'] as String,
        outOfBedTime: json['outOfBedTime'] as String,
        napMinutes: (json['napMinutes'] as num?)?.toInt(),
      );
}

class ParticipantSessionResult {
  const ParticipantSessionResult({
    required this.profile,
    required this.token,
    required this.expiresAt,
    this.accessCode,
  });
  final ParticipantProfile profile;
  final String token;
  final DateTime expiresAt;
  final String? accessCode;
}

class ParticipantApiException implements Exception {
  const ParticipantApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class ParticipantExportFile {
  const ParticipantExportFile({
    required this.bytes,
    required this.filename,
    required this.mimeType,
  });

  final Uint8List bytes;
  final String filename;
  final String mimeType;
}

abstract interface class ParticipantGateway {
  Future<ParticipantSessionResult> register({
    required String initials,
    int? age,
    String? gender,
    required String registrationKey,
  });
  Future<ParticipantSessionResult> login(String accessCode);
  Future<ParticipantProfile> me(String token);
  Future<List<ProgramSessionProgress>> progress(String token);
  Future<List<ProgramSessionProgress>> recordProgress(
    String token,
    String sessionId,
    String action,
  );
  Future<List<SleepDiaryEntry>> diary(String token);
  Future<SleepDiaryEntry> saveDiary(String token, Map<String, dynamic> input);
  Future<String> createDiaryLink(String token);
  Future<void> deleteDiary(String token, String sleepDate);
  Future<ParticipantExportFile> exportDiary(
    String token, {
    required String from,
    required String to,
  });
}

class HttpParticipantGateway implements ParticipantGateway {
  HttpParticipantGateway({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();
  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String> query = const {}]) {
    if (baseUrl.isEmpty) {
      throw const ParticipantApiException(
        'Layanan peserta belum dikonfigurasi.',
      );
    }
    final base = Uri.tryParse(baseUrl);
    if (base == null || !base.hasScheme || base.host.isEmpty) {
      throw const ParticipantApiException(
        'Layanan peserta belum dikonfigurasi.',
      );
    }
    if (kReleaseMode && base.scheme != 'https') {
      throw const ParticipantApiException(
        'Layanan peserta harus menggunakan koneksi aman.',
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
  }) async {
    try {
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      if (body != null) {
        headers['Content-Type'] = 'application/json';
      }
      final uri = _uri(path);
      final response =
          await (method == 'POST'
                  ? _client.post(
                      uri,
                      headers: headers,
                      body: body == null ? null : jsonEncode(body),
                    )
                  : method == 'DELETE'
                  ? _client.delete(
                      uri,
                      headers: headers,
                      body: body == null ? null : jsonEncode(body),
                    )
                  : _client.get(uri, headers: headers))
              .timeout(const Duration(seconds: 12));
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid response');
      }
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded['success'] != true) {
        throw ParticipantApiException(
          decoded['message'] is String
              ? decoded['message'] as String
              : 'Permintaan belum berhasil.',
          statusCode: response.statusCode,
        );
      }
      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid data');
      }
      return data;
    } on ParticipantApiException {
      rethrow;
    } catch (_) {
      throw const ParticipantApiException(
        'Tidak dapat terhubung. Periksa koneksi lalu coba lagi.',
      );
    }
  }

  ParticipantSessionResult _session(
    Map<String, dynamic> data, {
    String? suppliedCode,
  }) {
    final profile = data['participant'];
    final token = data['accessToken'];
    final expiry = data['expiresAt'];
    if (profile is! Map<String, dynamic> ||
        token is! String ||
        expiry is! String) {
      throw const FormatException('Invalid session');
    }
    return ParticipantSessionResult(
      profile: ParticipantProfile.fromJson(profile),
      token: token,
      expiresAt: DateTime.parse(expiry),
      accessCode: data['accessCode'] as String? ?? suppliedCode,
    );
  }

  @override
  Future<ParticipantSessionResult> register({
    required String initials,
    int? age,
    String? gender,
    required String registrationKey,
  }) async {
    final data = await _request(
      '/api/participant/register',
      method: 'POST',
      body: {
        'initials': initials,
        'ageAtEnrollment': ?age,
        'gender': ?gender,
        'registrationKey': registrationKey,
      },
    );
    return _session(data);
  }

  @override
  Future<ParticipantSessionResult> login(String accessCode) async => _session(
    await _request(
      '/api/participant/login',
      method: 'POST',
      body: {'accessCode': accessCode},
    ),
    suppliedCode: accessCode,
  );

  @override
  Future<ParticipantProfile> me(String token) async {
    final data = await _request('/api/participant/me', token: token);
    final profile = data['participant'];
    if (profile is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile');
    }
    return ParticipantProfile.fromJson(profile);
  }

  List<ProgramSessionProgress> _progress(Map<String, dynamic> data) {
    final sessions = data['sessions'];
    if (sessions is! List) throw const FormatException('Invalid progress');
    return sessions
        .map((item) {
          if (item is! Map<String, dynamic> ||
              item['id'] is! String ||
              item['status'] is! String) {
            throw const FormatException('Invalid session progress');
          }
          return ProgramSessionProgress(
            id: item['id'] as String,
            status: item['status'] as String,
          );
        })
        .toList(growable: false);
  }

  @override
  Future<List<ProgramSessionProgress>> progress(String token) async =>
      _progress(await _request('/api/participant/progress', token: token));

  @override
  Future<List<ProgramSessionProgress>> recordProgress(
    String token,
    String sessionId,
    String action,
  ) async => _progress(
    await _request(
      '/api/participant/progress',
      method: 'POST',
      token: token,
      body: {'sessionId': sessionId, 'action': action},
    ),
  );

  @override
  Future<List<SleepDiaryEntry>> diary(String token) async {
    final data = await _request('/api/participant/diary', token: token);
    final entries = data['entries'];
    if (entries is! List) throw const FormatException('Invalid diary');
    return entries
        .whereType<Map<String, dynamic>>()
        .map(SleepDiaryEntry.fromJson)
        .toList(growable: false);
  }

  @override
  Future<SleepDiaryEntry> saveDiary(
    String token,
    Map<String, dynamic> input,
  ) async {
    final data = await _request(
      '/api/participant/diary',
      method: 'POST',
      token: token,
      body: input,
    );
    final entry = data['entry'];
    if (entry is! Map<String, dynamic>)
      throw const FormatException('Invalid diary');
    return SleepDiaryEntry.fromJson(entry);
  }

  @override
  Future<String> createDiaryLink(String token) async {
    final data = await _request(
      '/api/participant/diary-link',
      method: 'POST',
      token: token,
      body: const {},
    );
    if (data['url'] is! String) {
      throw const FormatException('Invalid diary link');
    }
    return data['url'] as String;
  }

  @override
  Future<void> deleteDiary(String token, String sleepDate) async {
    await _request(
      '/api/participant/diary',
      method: 'DELETE',
      token: token,
      body: {'sleepDate': sleepDate},
    );
  }

  @override
  Future<ParticipantExportFile> exportDiary(
    String token, {
    required String from,
    required String to,
  }) async {
    try {
      final response = await _client
          .get(
            _uri('/api/participant/diary-export', {'from': from, 'to': to}),
            headers: {'Accept': '*/*', 'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        var message = 'Ringkasan belum berhasil dibuat.';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            final serverMessage =
                decoded['message'] ?? decoded['statusMessage'];
            if (serverMessage is String && serverMessage.isNotEmpty) {
              message = serverMessage;
            }
          }
        } catch (_) {}
        throw ParticipantApiException(message, statusCode: response.statusCode);
      }
      final disposition = response.headers['content-disposition'] ?? '';
      final match = RegExp(r'filename="?([^";]+)').firstMatch(disposition);
      return ParticipantExportFile(
        bytes: response.bodyBytes,
        filename: match?.group(1) ?? 'disqam-ringkasan-tidur-$from-$to.xlsx',
        mimeType:
            response.headers['content-type'] ??
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
    } on ParticipantApiException {
      rethrow;
    } catch (_) {
      throw const ParticipantApiException(
        'Tidak dapat mengunduh ringkasan. Periksa koneksi lalu coba lagi.',
      );
    }
  }
}
