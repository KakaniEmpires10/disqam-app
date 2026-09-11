import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'native splash scales its entire bitmap inside the Android safe circle',
    () {
      final xml = File(
        'android/app/src/main/res/drawable/disqam_launch_icon.xml',
      ).readAsStringSync();
      double inset(String edge) =>
          double.parse(
            RegExp('android:inset$edge="([0-9.]+)%"')
                .firstMatch(xml)!
                .group(1)!,
          ) /
          100;
      final width = 1 - inset('Left') - inset('Right');
      final height = 1 - inset('Top') - inset('Bottom');
      expect(math.sqrt(width * width + height * height), lessThan(2 / 3));
      expect(width / height, closeTo(640 / 408, .001));
      expect(xml, contains('android:gravity="fill"'));
      expect(xml, isNot(contains('<item android:width=')));
      for (final qualifier in ['values-v31', 'values-night-v31']) {
        final theme = File('android/app/src/main/res/$qualifier/styles.xml')
            .readAsStringSync();
        expect(theme, contains('@drawable/disqam_launch_icon'));
      }
    },
  );
}
