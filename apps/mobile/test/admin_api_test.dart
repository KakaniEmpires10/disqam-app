import 'dart:convert';

import 'package:disqam/services/admin_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Map<String, dynamic> data) => http.Response(
  jsonEncode({'success': true, 'data': data}),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  test(
    'dashboard admin mobile reads the complete monitoring response',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/admin/dashboard');
        expect(request.headers['Authorization'], 'Bearer admin-token');
        return jsonResponse({
          'summary': {
            'totalParticipants': 48,
            'activeParticipants': 32,
            'startedLearning': 27,
            'completedLearning': 11,
          },
          'sessionProgress': [
            {
              'session': 'I',
              'title': 'Sesi I · Kenali Masalah Tidur',
              'completed': 20,
              'opened': 25,
              'total': 48,
            },
          ],
          'diarySummary': {
            'totalEntries': 130,
            'lastSevenDays': 21,
            'activeParticipants': 18,
            'note': 'Bukan penilaian klinis.',
          },
          'recentActivity': [
            {
              'code': 'DQ-ABCDEFG2',
              'initials': 'AS',
              'event': 'mengisi buku harian tidur',
              'time': '2026-09-11T10:00:00.000Z',
            },
          ],
        });
      });
      final api = HttpAdminGateway(
        baseUrl: 'https://example.test',
        client: client,
      );

      final dashboard = await api.dashboard('admin-token');

      expect(dashboard.summary.totalParticipants, 48);
      expect(dashboard.summary.activeParticipants, 32);
      expect(dashboard.sessionProgress.single.completed, 20);
      expect(dashboard.diarySummary.totalEntries, 130);
      expect(dashboard.recentActivity.single.code, 'DQ-ABCDEFG2');
    },
  );

  test(
    'participant filters and pagination are sent to the shared API',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/admin/participants');
        expect(request.url.queryParameters, {
          'page': '2',
          'search': 'DQ-K72',
          'gender': 'female',
          'progress': 'in-progress',
        });
        return jsonResponse({
          'items': [
            {
              'id': '01999999-9999-7999-8999-999999999999',
              'code': 'DQ-K72MPABC23',
              'initials': 'SR',
              'ageAtEnrollment': 67,
              'gender': 'female',
              'openedSessions': 3,
              'completedSessions': 2,
              'createdAt': '2026-09-01T00:00:00.000Z',
              'lastLearningActivityAt': '2026-09-10T00:00:00.000Z',
            },
          ],
          'page': 2,
          'pageSize': 20,
          'total': 41,
        });
      });
      final api = HttpAdminGateway(
        baseUrl: 'https://example.test',
        client: client,
      );

      final page = await api.participants(
        'admin-token',
        page: 2,
        search: ' DQ-K72 ',
        gender: 'female',
        progress: 'in-progress',
      );

      expect(page.items.single.initials, 'SR');
      expect(page.hasPrevious, true);
      expect(page.hasNext, true);
      expect(page.hasPagination, true);
    },
  );

  test('mobile export keeps server filename and binary contents', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/admin/export');
      expect(request.url.queryParameters, {
        'dataset': 'diary',
        'format': 'xlsx',
        'code': 'DQ-K72MPABC23',
        'from': '2026-09-01',
      });
      expect(request.headers['Authorization'], 'Bearer admin-token');
      return http.Response.bytes(
        [80, 75, 3, 4],
        200,
        headers: {
          'content-type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          'content-disposition':
              'attachment; filename="disqam-diary-2026-09-11.xlsx"',
        },
      );
    });
    final api = HttpAdminGateway(
      baseUrl: 'https://example.test',
      client: client,
    );

    final file = await api.exportData(
      'admin-token',
      dataset: 'diary',
      format: 'xlsx',
      filters: const {'code': 'DQ-K72MPABC23', 'from': '2026-09-01'},
    );

    expect(file.filename, 'disqam-diary-2026-09-11.xlsx');
    expect(file.bytes, [80, 75, 3, 4]);
    expect(file.mimeType, contains('spreadsheetml'));
  });
}
