import 'package:disqam/content/models.dart';
import 'package:disqam/services/appendix_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('appendix export creates a real xlsx with a safe DISQAM filename', () {
    const table = ReadingTable(
      title: 'Lampiran 2 · Rekap Efisiensi Tidur Mingguan',
      headers: ['Hari', 'SE (%)'],
      rows: [
        ['1', '85'],
      ],
      exportable: true,
    );

    final file = AppendixExport.build(table);

    expect(
      file.filename,
      'disqam - Lampiran 2 - Rekap Efisiensi Tidur Mingguan.xlsx',
    );
    expect(file.bytes, isNotEmpty);
    expect(file.bytes.take(2), [0x50, 0x4b]);
  });
}
