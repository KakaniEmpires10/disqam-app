import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

enum _ExportChoice { save, share }

/// Lets people keep a copy on the device without losing the existing share flow.
Future<void> chooseExportAction({
  required BuildContext context,
  required String filename,
  required Uint8List bytes,
  required String mimeType,
  required Future<void> Function() share,
}) async {
  final choice = await showModalBottomSheet<_ExportChoice>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Simpan atau bagikan',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            ListTile(
              minTileHeight: 56,
              leading: const Icon(Icons.save_alt_rounded),
              title: const Text('Simpan di perangkat'),
              subtitle: const Text('Pilih folder untuk menyimpan berkas'),
              onTap: () => Navigator.pop(sheetContext, _ExportChoice.save),
            ),
            ListTile(
              minTileHeight: 56,
              leading: const Icon(Icons.share_rounded),
              title: const Text('Bagikan'),
              subtitle: const Text('Kirim melalui aplikasi lain'),
              onTap: () => Navigator.pop(sheetContext, _ExportChoice.share),
            ),
          ],
        ),
      ),
    ),
  );
  if (!context.mounted || choice == null) return;
  if (choice == _ExportChoice.share) {
    await share();
    return;
  }

  final dot = filename.lastIndexOf('.');
  final name = dot > 0 ? filename.substring(0, dot) : filename;
  final extension = dot > 0 ? filename.substring(dot + 1) : '';
  final path = await FileSaver.instance.saveAs(
    name: name,
    bytes: bytes,
    fileExtension: extension,
    mimeType: MimeType.custom,
    customMimeType: mimeType,
  );
  if (context.mounted && path != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Berkas berhasil disimpan.')));
  }
}
