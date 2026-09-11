enum CalculationMode { bedtime, wakeTime }

class SleepTimeResult {
  const SleepTimeResult({required this.minuteOfDay, required this.dayOffset});
  final int minuteOfDay;
  final int dayOffset;
}

/// Arithmetic time planning only; never a clinical sleep prescription.
SleepTimeResult calculateSleepTime({
  required int anchorMinutes,
  required int durationMinutes,
  required CalculationMode mode,
}) {
  if (anchorMinutes < 0 || anchorMinutes >= 1440) {
    throw ArgumentError.value(anchorMinutes, 'anchorMinutes');
  }
  if (durationMinutes <= 0 || durationMinutes >= 1440) {
    throw ArgumentError.value(durationMinutes, 'durationMinutes');
  }
  final raw =
      anchorMinutes +
      (mode == CalculationMode.wakeTime ? durationMinutes : -durationMinutes);
  return SleepTimeResult(
    minuteOfDay: raw % 1440,
    dayOffset: (raw / 1440).floor(),
  );
}

String formatClock(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  return [
    if (hours > 0) '$hours jam',
    if (remainder > 0) '$remainder menit',
  ].join(' ');
}
