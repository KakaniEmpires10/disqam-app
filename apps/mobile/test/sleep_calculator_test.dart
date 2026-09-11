import 'package:disqam/domain/sleep_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bedtime crosses to previous day and retains minute precision', () {
    final result = calculateSleepTime(
      anchorMinutes: 6 * 60 + 15,
      durationMinutes: 7 * 60 + 30,
      mode: CalculationMode.bedtime,
    );
    expect(formatClock(result.minuteOfDay), '22:45');
    expect(result.dayOffset, -1);
  });

  test('wake time crosses midnight', () {
    final result = calculateSleepTime(
      anchorMinutes: 22 * 60 + 45,
      durationMinutes: 7 * 60 + 30,
      mode: CalculationMode.wakeTime,
    );
    expect(formatClock(result.minuteOfDay), '06:15');
    expect(result.dayOffset, 1);
  });

  test('same day, midnight and invalid values', () {
    expect(
      calculateSleepTime(
        anchorMinutes: 600,
        durationMinutes: 60,
        mode: CalculationMode.bedtime,
      ).dayOffset,
      0,
    );
    final midnight = calculateSleepTime(
      anchorMinutes: 1380,
      durationMinutes: 60,
      mode: CalculationMode.wakeTime,
    );
    expect(midnight.minuteOfDay, 0);
    expect(midnight.dayOffset, 1);
    for (final duration in [0, -1, 1440]) {
      expect(
        () => calculateSleepTime(
          anchorMinutes: 360,
          durationMinutes: duration,
          mode: CalculationMode.bedtime,
        ),
        throwsArgumentError,
      );
    }
  });
}
