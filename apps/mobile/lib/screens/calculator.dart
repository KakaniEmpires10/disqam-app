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
  final _formKey = GlobalKey<FormState>();
  final _hours = TextEditingController();
  final _minutes = TextEditingController();
  final _scroll = ScrollController();
  CalculationMode _mode = CalculationMode.bedtime;
  TimeOfDay? _anchor;
  SleepTimeResult? _result;
  int? _duration;
  String? _timeError;

  @override
  void dispose() {
    _hours.dispose();
    _minutes.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _clearResult() => setState(() => _result = null);

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _anchor ?? const TimeOfDay(hour: 6, minute: 0),
      helpText: _mode == CalculationMode.bedtime
          ? 'Pilih jam bangun'
          : 'Pilih jam tidur',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _anchor = result;
      _timeError = null;
      _result = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    setState(
      () => _timeError = _anchor == null ? 'Pilih jam terlebih dahulu.' : null,
    );
    if (!valid || _anchor == null) return;
    final duration = int.parse(_hours.text) * 60 + int.parse(_minutes.text);
    setState(() {
      _duration = duration;
      _result = calculateSleepTime(
        anchorMinutes: _anchor!.hour * 60 + _anchor!.minute,
        durationMinutes: duration,
        mode: _mode,
      );
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Widget _modeButton(CalculationMode mode, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Semantics(
      selected: _mode == mode,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: _mode == mode
              ? DisqamColors.navy
              : DisqamColors.surfaceAlt,
          foregroundColor: _mode == mode ? Colors.white : DisqamColors.navy,
        ),
        onPressed: () => setState(() {
          _mode = mode;
          _anchor = null;
          _result = null;
          _timeError = null;
        }),
        icon: Icon(
          _mode == mode ? Icons.radio_button_checked : Icons.radio_button_off,
        ),
        label: Text(label),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bedtime = _mode == CalculationMode.bedtime;
    final result = _result;
    return AppPage(
      controller: _scroll,
      eyebrow: 'ALAT BANTU',
      title: 'Kalkulator Waktu Tidur',
      subtitle:
          'Hitung jam tidur atau bangun berdasarkan durasi yang Anda pilih.',
      children: [
        if (result != null)
          NightSurface(
            moon: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('HASIL PERHITUNGAN', light: true),
                const SizedBox(height: 20),
                Semantics(
                  liveRegion: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bedtime
                            ? 'Perkiraan jam tidur'
                            : 'Perkiraan jam bangun',
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFFD8E9EE),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatClock(result.minuteOfDay),
                        style: const TextStyle(
                          fontSize: 46,
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.dayOffset < 0
                            ? 'Hari sebelumnya'
                            : result.dayOffset > 0
                            ? 'Hari berikutnya'
                            : 'Hari yang sama',
                        style: const TextStyle(
                          color: Color(0xFFF3BC58),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Durasi pilihan: ${formatDuration(_duration!)}.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (result != null) const SizedBox(height: 24),
        const Eyebrow('01 · PILIH PERHITUNGAN'),
        const SizedBox(height: 12),
        Text(
          'Apa yang ingin dihitung?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _modeButton(CalculationMode.bedtime, 'Cari jam tidur'),
        _modeButton(CalculationMode.wakeTime, 'Cari jam bangun'),
        const SizedBox(height: 16),
        const Eyebrow('02 · TENTUKAN WAKTU'),
        const SizedBox(height: 12),
        Text(
          bedtime ? 'Jam bangun yang dipilih' : 'Jam tidur yang dipilih',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _pickTime,
          icon: const Icon(Icons.schedule),
          label: Text(
            _anchor == null
                ? 'Pilih jam'
                : formatClock(_anchor!.hour * 60 + _anchor!.minute),
          ),
        ),
        if (_timeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _timeError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 24),
        const Eyebrow('03 · MASUKKAN DURASI'),
        const SizedBox(height: 12),
        Text(
          'Durasi yang dipilih',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan jam dan menit. Isi 0 pada bagian yang tidak digunakan.',
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('duration-hours'),
                controller: _hours,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Jam',
                  hintText: 'Masukkan jumlah jam',
                  errorMaxLines: 3,
                ),
                onChanged: (_) => _clearResult(),
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null || number > 23) {
                    return 'Masukkan 0 sampai 23 jam.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('duration-minutes'),
                controller: _minutes,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Menit',
                  hintText: 'Masukkan jumlah menit',
                  errorMaxLines: 3,
                ),
                onChanged: (_) => _clearResult(),
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null || number > 59) {
                    return 'Masukkan 0 sampai 59 menit.';
                  }
                  if ((int.tryParse(_hours.text) ?? 0) == 0 && number == 0) {
                    return 'Durasi harus lebih dari 0 menit.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _calculate, child: const Text('Hitung waktu')),
        const SizedBox(height: 24),
        const InfoBox(
          'Kalkulator ini membantu menghitung waktu, bukan menentukan kebutuhan tidur atau jadwal terapi. Waktu di tempat tidur belum tentu seluruhnya digunakan untuk tidur. Hasil tidak memperhitungkan waktu menunggu tertidur atau terjaga pada malam hari.',
          label: 'Tentang hasil perhitungan',
        ),
      ],
    );
  }
}
