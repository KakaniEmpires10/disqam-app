import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/participant_api.dart';
import '../services/participant_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

String participantWhatsAppMessage(String code) =>
    'Ini kode kepesertaan Anda di DISQAM:\n\n$code\n\nSimpan kode ini untuk digunakan kembali jika Anda masuk dari HP yang berbeda. Jangan bagikan kepada orang lain.';

Uri participantWhatsAppUri(String code) => Uri.parse(
  'https://wa.me/?text=${Uri.encodeComponent(participantWhatsAppMessage(code))}',
);

Future<bool> ensureParticipantAccess(
  BuildContext context,
  ParticipantStore? store,
) async {
  if (store == null || store.registered) return true;
  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: DisqamColors.background,
        builder: (_) => ParticipantAccessSheet(store: store),
      ) ??
      false;
}

Future<void> showParticipantCode(
  BuildContext context,
  ParticipantStore store,
) async {
  final code = store.accessCode;
  if (code == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode belum tersimpan di perangkat ini.')),
    );
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: DisqamColors.background,
    builder: (sheetContext) =>
        _AccessCodeView(code: code, onDone: () => Navigator.pop(sheetContext)),
  );
}

class ParticipantAccessSheet extends StatefulWidget {
  const ParticipantAccessSheet({super.key, required this.store});
  final ParticipantStore store;
  @override
  State<ParticipantAccessSheet> createState() => _ParticipantAccessSheetState();
}

class _ParticipantAccessSheetState extends State<ParticipantAccessSheet> {
  final _initials = TextEditingController();
  final _age = TextEditingController();
  final _code = TextEditingController();
  String? _gender;
  bool _login = false;
  bool _working = false;
  String? _error;
  String? _newCode;

  @override
  void dispose() {
    _initials.dispose();
    _age.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);
    setState(() => _working = true);
    try {
      if (_login) {
        if (_code.text.trim().isEmpty) {
          setState(() => _error = 'Masukkan kode kepesertaan Anda.');
          return;
        }
        await widget.store.login(_code.text);
        if (mounted) Navigator.pop(context, true);
        return;
      }
      final initials = _initials.text.trim();
      if (initials.isEmpty || initials.length > 10) {
        setState(() => _error = 'Masukkan inisial, maksimal 10 karakter.');
        return;
      }
      int? age;
      if (_age.text.trim().isNotEmpty) {
        age = int.tryParse(_age.text.trim());
        if (age == null || age < 0 || age > 130) {
          setState(() => _error = 'Masukkan usia yang valid.');
          return;
        }
      }
      final result = await widget.store.register(
        initials: initials,
        age: age,
        gender: _gender,
      );
      if (mounted) {
        setState(() => _newCode = result.accessCode);
      }
    } on ParticipantApiException catch (error) {
      if (mounted) {
        setState(() => _error = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Data belum berhasil disimpan. Periksa koneksi lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_newCode != null) {
      return _AccessCodeView(
        code: _newCode!,
        onDone: () => Navigator.pop(context, true),
      );
    }
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 160),
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: DisqamColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Eyebrow('PROGRAM DISQAM'),
            const SizedBox(height: 10),
            Text(
              _login ? 'Masuk sebagai peserta' : 'Mulai mengikuti program',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              _login ? 'Gunakan kode kepesertaan yang pernah Anda simpan.' : 'Isi data singkat ini satu kali agar perkembangan sesi dapat tersimpan.',
            ),
            const SizedBox(height: 24),
            if (_login)
              TextField(
                key: const ValueKey('participant-code'),
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [LengthLimitingTextInputFormatter(40)],
                decoration: const InputDecoration(
                  labelText: 'Kode kepesertaan',
                  hintText: 'DQ-XXXXXXXXXX-XXXXXXXXXXXX',
                ),
              )
            else ...[
              TextField(
                key: const ValueKey('participant-initials'),
                controller: _initials,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                decoration: const InputDecoration(
                  labelText: 'Inisial',
                  hintText: 'Contoh: AB',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('participant-age'),
                controller: _age,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'Usia (opsional)',
                  hintText: 'Contoh: 70',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const ValueKey('participant-gender'),
                initialValue: _gender,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Jenis kelamin (opsional)',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'female',
                    child: Text('Perempuan', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem(
                    value: 'male',
                    child: Text('Laki-laki', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem(
                    value: 'unspecified',
                    child: Text(
                      'Tidak ingin menjawab',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                onChanged: _working
                    ? null
                    : (value) => setState(() => _gender = value),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 18),
              InfoBox(_error!, warm: true, label: 'Belum berhasil'),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _working ? null : _submit,
              child: Text(
                _working
                    ? 'Sedang diproses…'
                    : _login
                    ? 'Masuk'
                    : 'Daftar dan lanjutkan',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _working
                  ? null
                  : () => setState(() {
                      _login = !_login;
                      _error = null;
                    }),
              child: Text(
                _login
                    ? 'Belum punya kode? Daftar'
                    : 'Sudah punya kode kepesertaan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessCodeView extends StatelessWidget {
  const _AccessCodeView({required this.code, required this.onDone});
  final String code;
  final VoidCallback onDone;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kode berhasil disalin.')));
    }
  }

  Future<void> _whatsapp(BuildContext context) async {
    final uri = participantWhatsAppUri(code);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'WhatsApp belum dapat dibuka. Salin kode secara manual.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.verified_rounded,
          size: 54,
          color: DisqamColors.primary,
        ),
        const SizedBox(height: 18),
        Text(
          'Simpan kode Anda',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Kode ini diperlukan ketika Anda menggunakan DISQAM dari telepon genggam (HP) lain. Simpan di tempat pribadi.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Semantics(
          label: 'Kode kepesertaan $code',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DisqamColors.border),
            ),
            child: SelectableText(
              code,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: .8,
                color: DisqamColors.navy,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () => _copy(context),
          child: const Text('Salin kode', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _whatsapp(context),
          child: const Text(
            'Simpan melalui WhatsApp',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        const InfoBox(
          'Siapa pun yang memiliki kode ini dapat membuka data DISQAM Anda. Jangan kirim ke grup atau orang yang tidak dipercaya.',
          warm: true,
          label: 'Jaga kode Anda',
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onDone,
          child: const Text('Saya sudah menyimpan kode'),
        ),
      ],
    ),
  );
}
