enum SleepEfficiencyLevel { efficient, belowTarget }

class SleepEfficiencyResult {
  const SleepEfficiencyResult({
    required this.timeInBedMinutes,
    required this.totalSleepMinutes,
    required this.sleepEfficiency,
  });

  final int timeInBedMinutes;
  final int totalSleepMinutes;
  final double sleepEfficiency;

  SleepEfficiencyLevel get level => sleepEfficiency >= 85
      ? SleepEfficiencyLevel.efficient
      : SleepEfficiencyLevel.belowTarget;
}

int overnightMinutes(int endMinutes, int startMinutes) {
  if (startMinutes < 0 || startMinutes >= 1440) {
    throw ArgumentError.value(startMinutes, 'startMinutes');
  }
  if (endMinutes < 0 || endMinutes >= 1440) {
    throw ArgumentError.value(endMinutes, 'endMinutes');
  }
  final difference = endMinutes - startMinutes;
  return difference >= 0 ? difference : difference + 1440;
}

SleepEfficiencyResult calculateSleepEfficiency({
  required int bedTimeMinutes,
  required int outOfBedMinutes,
  required int sleepOnsetLatencyMinutes,
  required int wakeAfterSleepOnsetMinutes,
  int otherAwakeMinutes = 0,
}) {
  for (final value in [
    sleepOnsetLatencyMinutes,
    wakeAfterSleepOnsetMinutes,
    otherAwakeMinutes,
  ]) {
    if (value < 0 || value >= 1440) {
      throw ArgumentError.value(value, 'awakeMinutes');
    }
  }

  final timeInBed = overnightMinutes(outOfBedMinutes, bedTimeMinutes);
  if (timeInBed == 0) {
    throw ArgumentError('Waktu di tempat tidur harus lebih dari 0 menit.');
  }
  final totalAwake =
      sleepOnsetLatencyMinutes + wakeAfterSleepOnsetMinutes + otherAwakeMinutes;
  final totalSleep = timeInBed - totalAwake;
  if (totalSleep <= 0) {
    throw ArgumentError(
      'Jumlah waktu terjaga harus lebih singkat dari waktu di tempat tidur.',
    );
  }
  return SleepEfficiencyResult(
    timeInBedMinutes: timeInBed,
    totalSleepMinutes: totalSleep,
    sleepEfficiency: (totalSleep / timeInBed * 1000).round() / 10,
  );
}

int clockMinutes(String value) {
  final parts = value.split(':');
  if (parts.length != 2) throw FormatException('Jam tidak valid: $value');
  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);
  if (hours == null ||
      minutes == null ||
      hours < 0 ||
      hours > 23 ||
      minutes < 0 ||
      minutes > 59) {
    throw FormatException('Jam tidak valid: $value');
  }
  return hours * 60 + minutes;
}

String formatClock(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  return [
    if (hours > 0) '$hours jam',
    if (remainder > 0) '$remainder menit',
  ].join(' ');
}
