import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final before = TextEditingController(text: '0');
  final sol = TextEditingController(text: '0');
  final waso = TextEditingController(text: '0');
  final after = TextEditingController(text: '0');
  TimeOfDay? bedTime;
  TimeOfDay? outOfBedTime;
  int dayOffset = 1;
  SleepEfficiencyResult? result;
  String? timeError;
  String? calculationError;
  bool usingExample = false;

  @override
  void dispose() {
    before.dispose();
    sol.dispose();
    waso.dispose();
    after.dispose();
    super.dispose();
  }

  void invalidate() => setState(() {
    result = null;
    calculationError = null;
    usingExample = false;
  });

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
      usingExample = false;
    });
  }

  void calculate() {
    FocusScope.of(context).unfocus();
    final valid = formKey.currentState?.validate() ?? false;
    setState(() {
      timeError = bedTime == null || outOfBedTime == null
          ? 'Pilih jam masuk dan jam keluar tempat tidur.'
          : null;
      calculationError = null;
    });
    if (!valid || bedTime == null || outOfBedTime == null) return;
    try {
      final calculated = calculateSleepEfficiency(
        bedTimeMinutes: bedTime!.hour * 60 + bedTime!.minute,
        outOfBedMinutes: outOfBedTime!.hour * 60 + outOfBedTime!.minute,
        outOfBedDayOffset: dayOffset,
        beforeAttemptMinutes: int.parse(before.text),
        sleepOnsetLatencyMinutes: int.parse(sol.text),
        wakeAfterSleepOnsetMinutes: int.parse(waso.text),
        afterFinalAwakeningMinutes: int.parse(after.text),
      );
      setState(() => result = calculated);
    } on ArgumentError catch (error) {
      setState(() {
        result = null;
        calculationError = error.message?.toString() ?? 'Data belum valid.';
      });
    }
  }

  void useExample() {
    setState(() {
      bedTime = const TimeOfDay(hour: 21, minute: 30);
      outOfBedTime = const TimeOfDay(hour: 6, minute: 0);
      dayOffset = 1;
      before.text = '30';
      sol.text = '30';
      waso.text = '45';
      after.text = '15';
      usingExample = true;
      timeError = null;
      calculationError = null;
    });
    calculate();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    eyebrow: 'ALAT BANTU',
    title: 'Kalkulator Tidur Saya',
    subtitle: 'Hitung perkiraan lama tidur dan persentase waktu di tempat tidur yang digunakan untuk tidur.',
    children: [
      const InfoBox(
        'Isi pada pagi hari untuk satu periode tidur utama. Gunakan perkiraan terbaik; tidak perlu terus melihat jam saat malam. Pendamping boleh membantu. Tidur siang dicatat terpisah.',
        label: 'Sebelum menghitung',
      ),
      const SizedBox(height: 26),
      Text(
        '1. Jam masuk dan keluar',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      const Text('Gunakan format 24 jam. Contoh: pukul 10 malam adalah 22.00.'),
      const SizedBox(height: 14),
      _TimeButton(
        label: 'Jam masuk tempat tidur',
        helper: 'Awal periode tidur utama.',
        value: bedTime,
        onPressed: () => pickTime(true),
      ),
      const SizedBox(height: 12),
      _TimeButton(
        label: 'Jam keluar tempat tidur',
        helper: 'Saat bangun untuk memulai hari, bukan saat ke toilet lalu tidur lagi.',
        value: outOfBedTime,
        onPressed: () => pickTime(false),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        initialValue: dayOffset,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Keluar tempat tidur pada',
        ),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Hari berikutnya')),
          DropdownMenuItem(value: 0, child: Text('Hari yang sama')),
        ],
        onChanged: (value) => setState(() {
          dayOffset = value ?? 1;
          result = null;
          calculationError = null;
        }),
      ),
      if (timeError != null) ...[
        const SizedBox(height: 8),
        Text(
          timeError!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
      const SizedBox(height: 28),
      Text('2. Lama terjaga', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text(
        'Isi dalam menit. Jika tidak ada, isi 0. Setengah jam = 30 menit; satu jam = 60 menit.',
      ),
      const SizedBox(height: 14),
      Form(
        key: formKey,
        child: Column(
          children: [
            _MinuteField(
              key: const ValueKey('before-attempt'),
              controller: before,
              label: 'Sebelum mulai mencoba tidur',
              helper: 'Sejak masuk tempat tidur hingga mulai berusaha tidur, misalnya masih membaca.',
              onChanged: (_) => invalidate(),
            ),
            const SizedBox(height: 16),
            _MinuteField(
              key: const ValueKey('sleep-onset-latency'),
              controller: sol,
              label: 'Waktu hingga tertidur (SOL)',
              helper:
                  'Sejak mulai berusaha tidur sampai pertama kali tertidur.',
              onChanged: (_) => invalidate(),
            ),
            const SizedBox(height: 16),
            _MinuteField(
              key: const ValueKey('wake-after-sleep-onset'),
              controller: waso,
              label: 'Terjaga di tengah tidur (WASO)',
              helper: 'Jumlah seluruh waktu terbangun lalu tidur kembali, termasuk ke toilet.',
              onChanged: (_) => invalidate(),
            ),
            const SizedBox(height: 16),
            _MinuteField(
              key: const ValueKey('after-final-awakening'),
              controller: after,
              label: 'Setelah bangun terakhir',
              helper: 'Sejak bangun dan tidak tidur lagi hingga keluar tempat tidur untuk memulai hari.',
              onChanged: (_) => invalidate(),
            ),
          ],
        ),
      ),
      if (calculationError != null) ...[
        const SizedBox(height: 14),
        InfoBox(calculationError!, warm: true, label: 'Periksa kembali'),
      ],
      const SizedBox(height: 22),
      FilledButton.icon(
        onPressed: calculate,
        icon: const Icon(Icons.calculate_outlined),
        label: const Text('Hitung tidur saya'),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: useExample,
        icon: const Icon(Icons.science_outlined),
        label: const Text('Coba contoh'),
      ),
      if (usingExample) ...[
        const SizedBox(height: 10),
        const Text('Ini data contoh. Ganti dengan catatan tidur Anda.'),
      ],
      if (result != null) ...[
        const SizedBox(height: 26),
        _ResultCard(result: result!),
        const SizedBox(height: 16),
        const _CalculationDetails(),
        const SizedBox(height: 16),
        const InfoBox(
          'Hasil ini adalah perkiraan dari catatan pribadi, bukan diagnosis. Lihat pola beberapa malam dan kondisi tubuh pada siang hari. Penyesuaian jadwal atau pembatasan waktu tidur perlu dibahas dengan tenaga kesehatan.',
          label: 'Perlu diingat',
        ),
        const SizedBox(height: 16),
        const _ScientificReferences(),
      ],
    ],
  );
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.helper,
    required this.value,
    required this.onPressed,
  });
  final String label;
  final String helper;
  final TimeOfDay? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    child: Row(
      children: [
        const Icon(Icons.schedule_rounded),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 3),
              Text(
                value == null
                    ? helper
                    : formatClock(value!.hour * 60 + value!.minute),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 4),
      Text(helper, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onChanged: onChanged,
        decoration: const InputDecoration(hintText: '0', suffixText: 'menit'),
        validator: (value) {
          final number = int.tryParse(value ?? '');
          if (number == null || number < 0 || number >= 1440) {
            return 'Masukkan angka bulat dari 0 sampai 1439.';
          }
          return null;
        },
      ),
    ],
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Eyebrow('HASIL PERKIRAAN TIDUR', light: true),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (result.sleepEfficiency / 100).clamp(0, 1),
                minHeight: 14,
                backgroundColor: const Color(0xFF31536C),
                color: const Color(0xFF82D1D8),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              efficient
                  ? 'Sudah mencapai patokan efisiensi tidur umum.'
                  : 'Belum mencapai patokan efisiensi tidur umum.',
              style: const TextStyle(
                color: Color(0xFFF3BC58),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Patokan umum efisiensi tidur adalah 85% atau lebih. Angka ini bukan batas diagnosis.',
              style: TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Sekitar ${result.sleepEfficiency.round()} dari setiap 100 menit di tempat tidur digunakan untuk tidur.',
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 18),
            _ResultLine(
              label: 'Waktu di tempat tidur (TIB)',
              value: formatDuration(result.timeInBedMinutes),
            ),
            _ResultLine(
              label: 'Waktu hingga tertidur (SOL)',
              value: formatDuration(result.sleepOnsetLatencyMinutes),
            ),
            _ResultLine(
              label: 'Terjaga di tengah tidur (WASO)',
              value: formatDuration(result.wakeAfterSleepOnsetMinutes),
            ),
            _ResultLine(
              label: 'Total tidur (TST)',
              value: formatDuration(result.totalSleepMinutes),
            ),
            const SizedBox(height: 12),
            Text(
              'TST = ${result.timeInBedMinutes} − ${result.beforeAttemptMinutes} − ${result.sleepOnsetLatencyMinutes} − ${result.wakeAfterSleepOnsetMinutes} − ${result.afterFinalAwakeningMinutes} = ${result.totalSleepMinutes} menit.\nSE = ${result.totalSleepMinutes} ÷ ${result.timeInBedMinutes} × 100 = ${result.sleepEfficiency.toStringAsFixed(1)}%.',
              style: const TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
            ),
            const SizedBox(height: 14),
            const Text(
              'Angka tinggi belum tentu berarti lama tidur sudah cukup atau semua masalah tidur sudah teratasi.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFD8E9EE), fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _CalculationDetails extends StatelessWidget {
  const _CalculationDetails();
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: ExpansionTile(
      title: const Text('Cara menghitung dan arti istilah'),
      leading: const Icon(
        Icons.menu_book_outlined,
        color: DisqamColors.primary,
      ),
      shape: const Border(),
      collapsedShape: const Border(),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      children: const [
        _Definition(
          'TIB (Time in Bed)',
          'Selang waktu dari masuk tempat tidur sampai keluar untuk memulai hari, termasuk waktu terbangun di tengah malam.',
        ),
        _Definition(
          'SOL (Sleep Onset Latency)',
          'Waktu untuk mulai tertidur setelah berusaha tidur.',
        ),
        _Definition(
          'WASO (Wake After Sleep Onset)',
          'Total terjaga setelah pertama tertidur dan sebelum bangun terakhir. Waktu setelah bangun terakhir dihitung terpisah agar tidak dikurangkan dua kali.',
        ),
        _Definition(
          'TST (Total Sleep Time)',
          'Perkiraan total waktu benar-benar tidur.',
        ),
        _Definition(
          'Rumus TST',
          'TST = TIB − waktu sebelum mencoba tidur − SOL − WASO − waktu setelah bangun terakhir.',
        ),
        _Definition('Rumus SE', 'SE (%) = TST ÷ TIB × 100.'),
        _Definition(
          'Batas perhitungan',
          'Semua durasi dihitung dalam menit dan satu periode tidur harus kurang dari 24 jam. Gunakan definisi yang sama pada seluruh catatan penelitian.',
        ),
      ],
    ),
  );
}

class _Definition extends StatelessWidget {
  const _Definition(this.title, this.text);
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    ),
  );
}

class _ScientificReferences extends StatelessWidget {
  const _ScientificReferences();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Rujukan ilmiah', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text(
          'Kalkulator edukasi ini mengacu pada komponen buku harian tidur dan bukan instrumen baru yang sudah divalidasi.',
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => launchUrl(
            Uri.parse('https://doi.org/10.5665/sleep.1642'),
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.open_in_new_rounded),
          label: const Text('Carney et al. (2012) · Consensus Sleep Diary'),
        ),
        TextButton.icon(
          onPressed: () => launchUrl(
            Uri.parse('https://doi.org/10.5664/jcsm.5498'),
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.open_in_new_rounded),
          label: const Text('Reed & Sacco (2016) · Measuring Sleep Efficiency'),
        ),
      ],
    ),
  );
}
