import 'dart:io';
import 'dart:typed_data';

/// Packages existing DISQAM PNGs at common Windows icon sizes.
/// Run from apps/mobile: dart run tool/create_windows_icon.dart
void main() {
  final target = File('windows/runner/resources/app_icon.ico');
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  const sizes = [16, 32, 64, 128, 256];
  final images = <Uint8List>[];
  for (final size in sizes) {
    final source = File(
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_$size.png',
    );
    final png = source.readAsBytesSync();
    final pngHeader = ByteData.sublistView(png);
    if (png.length < 24 ||
        !Iterable<int>.generate(8)
            .every((index) => png[index] == signature[index]) ||
        pngHeader.getUint32(16) != size ||
        pngHeader.getUint32(20) != size) {
      throw StateError('Ikon sumber harus PNG $size×$size: ${source.path}');
    }
    images.add(png);
  }

  final directorySize = 6 + sizes.length * 16;
  final icon = Uint8List(
    directorySize + images.fold<int>(0, (sum, png) => sum + png.length),
  );
  final header = ByteData.sublistView(icon);
  header.setUint16(2, 1, Endian.little); // icon type
  header.setUint16(4, sizes.length, Endian.little);
  var offset = directorySize;
  for (var index = 0; index < sizes.length; index++) {
    final entry = 6 + index * 16;
    final png = images[index];
    icon[entry] = sizes[index] == 256 ? 0 : sizes[index];
    icon[entry + 1] = sizes[index] == 256 ? 0 : sizes[index];
    header.setUint16(entry + 4, 1, Endian.little);
    header.setUint16(entry + 6, 32, Endian.little);
    header.setUint32(entry + 8, png.length, Endian.little);
    header.setUint32(entry + 12, offset, Endian.little);
    icon.setRange(offset, offset + png.length, png);
    offset += png.length;
  }

  target.writeAsBytesSync(icon);
}
