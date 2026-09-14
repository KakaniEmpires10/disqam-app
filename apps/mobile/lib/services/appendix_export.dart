import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';

import '../content/models.dart';

class AppendixExportFile {
  const AppendixExportFile({required this.filename, required this.bytes});

  final String filename;
  final Uint8List bytes;
}

class AppendixExport {
  const AppendixExport._();

  static AppendixExportFile build(ReadingTable table) {
    final workbook = Excel.createExcel();
    final sheet = workbook['Lampiran'];
    if (workbook.tables.containsKey('Sheet1')) workbook.delete('Sheet1');

    sheet.appendRow(table.headers.map(TextCellValue.new).toList());
    for (final row in table.rows) {
      sheet.appendRow([
        for (var index = 0; index < table.headers.length; index++)
          TextCellValue(index < row.length ? row[index] : ''),
      ]);
    }

    final headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#0D7B8E'),
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
    );
    final bodyStyle = CellStyle(
      verticalAlign: VerticalAlign.Top,
      textWrapping: TextWrapping.WrapText,
    );
    for (final cell in sheet.row(0)) {
      cell?.cellStyle = headerStyle;
    }
    for (var row = 1; row <= table.rows.length; row++) {
      for (final cell in sheet.row(row)) {
        cell?.cellStyle = bodyStyle;
      }
    }
    for (var column = 0; column < table.headers.length; column++) {
      final values = <String>[
        table.headers[column],
        for (final row in table.rows)
          if (column < row.length) row[column],
      ];
      final longest = values.fold<int>(
        0,
        (value, text) => text.length > value ? text.length : value,
      );
      sheet.setColumnWidth(column, longest.clamp(12, 34).toDouble());
    }

    final encoded = workbook.encode();
    if (encoded == null) throw StateError('Berkas Excel gagal dibuat.');
    return AppendixExportFile(
      filename: 'disqam - ${_safeName(table.title)}.xlsx',
      bytes: Uint8List.fromList(encoded),
    );
  }

  static Future<void> share(ReadingTable table) async {
    final file = build(table);
    await SharePlus.instance.share(
      ShareParams(
        subject: table.title,
        text: 'Lampiran DISQAM: ${table.title}',
        files: [
          XFile.fromData(
            file.bytes,
            mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            name: file.filename,
          ),
        ],
        fileNameOverrides: [file.filename],
      ),
    );
  }

  static String _safeName(String value) => value
      .replaceAll('·', '-')
      .replaceAll(RegExp(r'[<>:"/\\|?*]'), '-')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
