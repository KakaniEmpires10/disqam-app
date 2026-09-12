import 'package:share_plus/share_plus.dart';

import 'participant_api.dart';

abstract final class ParticipantExport {
  static Future<void> share(ParticipantExportFile file) =>
      SharePlus.instance.share(
        ShareParams(
          subject: 'Ringkasan tidur DISQAM',
          text: 'Ringkasan buku harian tidur selama tujuh hari.',
          files: [
            XFile.fromData(
              file.bytes,
              mimeType: file.mimeType,
              name: file.filename,
            ),
          ],
          fileNameOverrides: [file.filename],
        ),
      );
}
