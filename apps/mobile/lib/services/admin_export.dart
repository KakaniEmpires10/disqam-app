import 'package:share_plus/share_plus.dart';

import 'admin_api.dart';

abstract final class AdminExportService {
  static Future<void> share(AdminExportFile file) => SharePlus.instance.share(
    ShareParams(
      subject: 'Ekspor data DISQAM',
      text: 'Data penelitian DISQAM',
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
