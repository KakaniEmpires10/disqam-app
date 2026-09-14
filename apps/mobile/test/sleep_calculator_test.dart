import 'package:disqam/domain/sleep_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculates overnight TIB, TST and sleep efficiency', () {
    final result = calculateSleepEfficiency(
      bedTimeMinutes: 21 * 60 + 30,
      outOfBedMinutes: 6 * 60,
      sleepOnsetLatencyMinutes: 30,
      wakeAfterSleepOnsetMinutes: 30,
    );
    expect(result.timeInBedMinutes, 510);
    expect(result.totalSleepMinutes, 450);
    expect(result.sleepEfficiency, 88.2);
    expect(result.level, SleepEfficiencyLevel.efficient);
  });

  test('includes other awake time and classifies below 85 percent', () {
    final result = calculateSleepEfficiency(
      bedTimeMinutes: 22 * 60,
      outOfBedMinutes: 6 * 60,
      sleepOnsetLatencyMinutes: 60,
      wakeAfterSleepOnsetMinutes: 45,
      otherAwakeMinutes: 15,
    );
    expect(result.timeInBedMinutes, 480);
    expect(result.totalSleepMinutes, 360);
    expect(result.sleepEfficiency, 75);
    expect(result.level, SleepEfficiencyLevel.belowTarget);
  });

  test('matches the calculator reference example', () {
    final result = calculateSleepEfficiency(
      bedTimeMinutes: 21 * 60 + 30,
      outOfBedMinutes: 6 * 60,
      outOfBedDayOffset: 1,
      beforeAttemptMinutes: 30,
      sleepOnsetLatencyMinutes: 30,
      wakeAfterSleepOnsetMinutes: 45,
      afterFinalAwakeningMinutes: 15,
    );
    expect(result.timeInBedMinutes, 510);
    expect(result.totalSleepMinutes, 390);
    expect(result.sleepEfficiency, 76.5);
    expect(result.beforeAttemptMinutes, 30);
    expect(result.afterFinalAwakeningMinutes, 15);
  });

  test('rejects zero TIB and permits a zero-minute sleep estimate', () {
    expect(
      () => calculateSleepEfficiency(
        bedTimeMinutes: 360,
        outOfBedMinutes: 360,
        sleepOnsetLatencyMinutes: 0,
        wakeAfterSleepOnsetMinutes: 0,
      ),
      throwsArgumentError,
    );
    final result = calculateSleepEfficiency(
      bedTimeMinutes: 22 * 60,
      outOfBedMinutes: 6 * 60,
      sleepOnsetLatencyMinutes: 240,
      wakeAfterSleepOnsetMinutes: 240,
    );
    expect(result.totalSleepMinutes, 0);
    expect(result.sleepEfficiency, 0);
  });

  test('clock parser validates values and duration remains readable', () {
    expect(clockMinutes('21:30'), 1290);
    expect(() => clockMinutes('25:00'), throwsFormatException);
    expect(formatDuration(450), '7 jam 30 menit');
  });
}
