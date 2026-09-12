import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/sleep_calculator.dart';
import '../theme.dart';
import '../widgets/common.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final formKey = GlobalKey<FormState>();
  final sol = TextEditingController(text: '0');
  final waso = TextEditingController(text: '0');
  final otherAwake = TextEditingController(text: '0');
  TimeOfDay? bedTime;
  TimeOfDay? outOfBedTime;
  SleepEfficiencyResult? result;
  String? timeError;
  String? calculationError;

  @override
  void dispose() {
    sol.dispose();
    waso.dispose();
    otherAwake.dispose();
    super.dispose();
  }

  Future<void> pickTime(bool bedtime) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: bedtime
          ? bedTime ?? const TimeOfDay(hour: 21, minute: 30)
          : outOfBedTime ?? const TimeOfDay(hour: 6, minute: 0),
      helpText: bedtime
          ? 'Pilih jam masuk tempat tidur'
          : 'Pilih jam keluar dari tempat tidur',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (bedtime) {
        bedTime = selected;
      } else {
        outOfBedTime = selected;
      }
      result = null;
      timeError = null;
      calculationError = null;
    });
  }

  void calculate() {
    FocusScope.of(context).unfocus();
    final valid = formKey.currentState?.validate() ?? false;
    setState(() {
      timeError = bedTime == null || outOfBedTime == null
          ? 'Pilih kedua waktu terlebih dahulu.'
          : null;
      calculationError = null;
    });
    if (!valid || bedTime == null || outOfBedTime == null) return;
    try {
      final calculated = calculateSleepEfficiency(
        bedTimeMinutes: bedTime!.hour * 60 + bedTime!.minute,
        outOfBedMinutes: outOfBedTime!.hour * 60 + outOfBedTime!.minute,
        sleepOnsetLatencyMinutes: int.parse(sol.text),
        wakeAfterSleepOnsetMinutes: int.parse(waso.text),
        otherAwakeMinutes: int.parse(otherAwake.text),
      );
      setState(() => result = calculated);
    } on ArgumentError catch (error) {
      setState(() {
        result = null;
        calculationError = error.message?.toString() ?? 'Data belum valid.';
      });
    }
  }

  void clearResult(String _) => setState(() {
    result = null;
    calculationError = null;
  });

  @override
  Widget build(BuildContext context) => AppPage(
    eyebrow: 'ALAT BANTU',
    title: 'Kalkulator Efisiensi Tidur',
    subtitle: 'Hitung berapa persen waktu di tempat tidur yang benar-benar digunakan untuk tidur.',
    children: [
      if (result != null) ...[
        _ResultCard(result: result!),
        const SizedBox(height: 24),
      ],
      const InfoBox(
        'Gunakan perkiraan waktu dari satu malam. Untuk melihat pola yang lebih bermakna, bandingkan hasil selama 7 malam.',
        label: 'Sebelum menghitung',
      ),
      const SizedBox(height: 24),
      Text(
        'Waktu di tempat tidur',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      const Text(
        'Pilih saat mulai berbaring untuk tidur dan saat benar-benar keluar dari tempat tidur.',
      ),
      const SizedBox(height: 14),
      _TimeButton(
        label: 'Jam masuk tempat tidur',
        value: bedTime,
        onPressed: () => pickTime(true),
      ),
      const SizedBox(height: 12),
      _TimeButton(
        label: 'Jam keluar dari tempat tidur',
        value: outOfBedTime,
        onPressed: () => pickTime(false),
      ),
      if (timeError != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            timeError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      const SizedBox(height: 26),
      Text('Waktu terjaga', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text('Isi dalam menit. Jika tidak ada, isi 0.'),
      const SizedBox(height: 14),
      Form(
        key: formKey,
        child: Column(
          children: [
            _MinuteField(
              key: const ValueKey('sleep-onset-latency'),
              controller: sol,
              label: 'Waktu sampai tertidur (SOL)',
              helper: 'Sejak mulai berusaha tidur sampai benar-benar tertidur.',
              onChanged: clearResult,
            ),
            const SizedBox(height: 16),
            _MinuteField(
              key: const ValueKey('wake-after-sleep-onset'),
              controller: waso,
              label: 'Total terjaga setelah tertidur (WASO)',
              helper: 'Jumlah seluruh waktu terjaga di tengah malam.',
              onChanged: clearResult,
            ),
            const SizedBox(height: 16),
            _MinuteField(
              key: const ValueKey('other-awake-minutes'),
              controller: otherAwake,
              label: 'Waktu terjaga lainnya',
              helper: 'Contoh: sudah bangun tetapi masih berbaring. Isi 0 jika tidak ada.',
              onChanged: clearResult,
            ),
          ],
        ),
      ),
      if (calculationError != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: InfoBox(
            calculationError!,
            warm: true,
            label: 'Periksa kembali',
          ),
        ),
      const SizedBox(height: 22),
      FilledButton.icon(
        onPressed: calculate,
        icon: const Icon(Icons.calculate_outlined),
        label: const Text('Hitung efisiensi tidur'),
      ),
      const SizedBox(height: 28),
      const _FormulaExplanation(),
    ],
  );
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final TimeOfDay? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.schedule_rounded),
    label: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value == null
            ? label
            : '$label: ${formatClock(value!.hour * 60 + value!.minute)}',
      ),
    ),
  );
}

class _MinuteField extends StatelessWidget {
  const _MinuteField({
    super.key,
    required this.controller,
    required this.label,
    required this.helper,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String helper;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(3),
    ],
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      helperText: helper,
      helperMaxLines: 3,
      suffixText: 'menit',
    ),
    validator: (value) {
      final number = int.tryParse(value ?? '');
      if (number == null || number < 0 || number > 999) {
        return 'Masukkan angka 0 sampai 999.';
      }
      return null;
    },
  );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final SleepEfficiencyResult result;

  @override
  Widget build(BuildContext context) {
    final efficient = result.level == SleepEfficiencyLevel.efficient;
    return NightSurface(
      moon: true,
      child: Semantics(
        liveRegion: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('HASIL PERHITUNGAN', light: true),
            const SizedBox(height: 14),
            Text(
              '${result.sleepEfficiency.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 46,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              efficient
                  ? 'Mencapai patokan efisiensi umum'
                  : 'Belum mencapai patokan efisiensi umum',
              style: const TextStyle(
                color: Color(0xFFF3BC58),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              efficient
                  ? 'Sebagian besar waktu di tempat tidur digunakan untuk tidur.'
                  : 'Masih cukup banyak waktu di tempat tidur yang digunakan dalam keadaan terjaga.',
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 16),
            Text(
              'TIB ${formatDuration(result.timeInBedMinutes)} · TST ${formatDuration(result.totalSleepMinutes)}',
              style: const TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaExplanation extends StatelessWidget {
  const _FormulaExplanation();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cara perhitungan', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        const Text(
          '1. TIB = waktu keluar dari tempat tidur − waktu masuk tempat tidur',
        ),
        const SizedBox(height: 10),
        const Text('2. TST = TIB − SOL − WASO − waktu terjaga lainnya'),
        const SizedBox(height: 10),
        const Text('3. SE = TST ÷ TIB × 100%'),
        const Divider(height: 30, color: DisqamColors.border),
        Text(
          'Apa arti hasilnya?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        const Text(
          'Efisiensi 85% atau lebih digunakan sebagai patokan umum bahwa waktu di tempat tidur cukup efisien. Nilai di bawah 85% berarti patokan tersebut belum tercapai.',
        ),
        const SizedBox(height: 10),
        const Text(
          'Hasil satu malam bukan diagnosis. Perhatikan pola selama beberapa malam. Jika hasil sering rendah dan Anda merasa mengantuk, lelah, atau sulit beraktivitas pada siang hari, bicarakan dengan tenaga kesehatan.',
        ),
        const SizedBox(height: 10),
        const Text(
          'Jangan mengurangi waktu tidur atau waktu di tempat tidur sendiri hanya berdasarkan angka ini.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
