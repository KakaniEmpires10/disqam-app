enum SleepEfficiencyLevel { efficient, belowTarget }

class SleepEfficiencyResult {
  const SleepEfficiencyResult({
    required this.timeInBedMinutes,
    required this.totalSleepMinutes,
    required this.sleepEfficiency,
    this.beforeAttemptMinutes = 0,
    this.sleepOnsetLatencyMinutes = 0,
    this.wakeAfterSleepOnsetMinutes = 0,
    this.afterFinalAwakeningMinutes = 0,
  });

  final int timeInBedMinutes;
  final int totalSleepMinutes;
  final double sleepEfficiency;
  final int beforeAttemptMinutes;
  final int sleepOnsetLatencyMinutes;
  final int wakeAfterSleepOnsetMinutes;
  final int afterFinalAwakeningMinutes;

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
  int beforeAttemptMinutes = 0,
  int afterFinalAwakeningMinutes = 0,
  int otherAwakeMinutes = 0,
  int? outOfBedDayOffset,
}) {
  for (final value in [
    beforeAttemptMinutes,
    sleepOnsetLatencyMinutes,
    wakeAfterSleepOnsetMinutes,
    afterFinalAwakeningMinutes,
    otherAwakeMinutes,
  ]) {
    if (value < 0 || value >= 1440) {
      throw ArgumentError.value(value, 'awakeMinutes');
    }
  }

  if (outOfBedDayOffset != null &&
      outOfBedDayOffset != 0 &&
      outOfBedDayOffset != 1) {
    throw ArgumentError.value(outOfBedDayOffset, 'outOfBedDayOffset');
  }
  final timeInBed = outOfBedDayOffset == null
      ? overnightMinutes(outOfBedMinutes, bedTimeMinutes)
      : outOfBedMinutes + outOfBedDayOffset * 1440 - bedTimeMinutes;
  if (timeInBed <= 0 || timeInBed >= 1440) {
    throw ArgumentError(
      'Periksa jam dan pilihan hari. Waktu keluar harus sesudah waktu masuk, dengan selang kurang dari 24 jam.',
    );
  }
  final totalAwake =
      beforeAttemptMinutes +
      sleepOnsetLatencyMinutes +
      wakeAfterSleepOnsetMinutes +
      afterFinalAwakeningMinutes +
      otherAwakeMinutes;
  final totalSleep = timeInBed - totalAwake;
  if (totalSleep < 0) {
    throw ArgumentError(
      'Jumlah waktu terjaga melebihi waktu masuk sampai keluar tempat tidur. Periksa angka dan pastikan waktu terjaga tidak dihitung dua kali.',
    );
  }
  return SleepEfficiencyResult(
    timeInBedMinutes: timeInBed,
    totalSleepMinutes: totalSleep,
    sleepEfficiency: (totalSleep / timeInBed * 1000).round() / 10,
    beforeAttemptMinutes: beforeAttemptMinutes,
    sleepOnsetLatencyMinutes: sleepOnsetLatencyMinutes,
    wakeAfterSleepOnsetMinutes: wakeAfterSleepOnsetMinutes,
    afterFinalAwakeningMinutes: afterFinalAwakeningMinutes + otherAwakeMinutes,
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
  if (minutes == 0) return '0 menit';
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  return [
    if (hours > 0) '$hours jam',
    if (remainder > 0) '$remainder menit',
  ].join(' ');
}
