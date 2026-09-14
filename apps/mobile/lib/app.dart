import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home.dart';
import 'screens/introduction.dart';
import 'services/reading_store.dart';
import 'services/participant_store.dart';
import 'services/admin_store.dart';
import 'theme.dart';

class DisqamApp extends StatelessWidget {
  const DisqamApp({
    super.key,
    required this.store,
    this.participants,
    this.admin,
    this.splashDuration = const Duration(milliseconds: 650),
  });
  final ReadingStore store;
  final ParticipantStore? participants;
  final AdminStore? admin;
  final Duration splashDuration;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DISQAM',
    debugShowCheckedModeBanner: false,
    theme: buildDisqamTheme(),
    themeMode: ThemeMode.light,
    locale: const Locale('id'),
    supportedLocales: const [Locale('id')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: _Startup(
      store: store,
      participants: participants,
      admin: admin,
      duration: splashDuration,
    ),
  );
}

class _Startup extends StatefulWidget {
  const _Startup({
    required this.store,
    required this.participants,
    required this.admin,
    required this.duration,
  });
  final ReadingStore store;
  final ParticipantStore? participants;
  final AdminStore? admin;
  final Duration duration;
  @override
  State<_Startup> createState() => _StartupState();
}

class _StartupState extends State<_Startup> {
  late final Future<void> _ready;
  bool _entered = false;
  @override
  void initState() {
    super.initState();
    _ready = Future.wait([
      widget.store.load(),
      if (widget.participants != null) widget.participants!.load(),
      if (widget.admin != null) widget.admin!.load(),
      Future<void>.delayed(widget.duration),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _ready,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/mark.webp',
                      width: 164,
                      height: 164,
                      fit: BoxFit.contain,
                      semanticLabel: 'DISQAM',
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Mengenal tidur, menjaga kualitas hidup.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        semanticsLabel: 'Membuka aplikasi',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      if (_entered) {
        return HomePage(
          store: widget.store,
          participants: widget.participants,
          admin: widget.admin,
        );
      }
      return IntroductionPage(
        onStart: () {
          widget.store.finishIntroduction();
          setState(() => _entered = true);
        },
        storageUnavailable: widget.store.storageUnavailable,
      );
    },
  );
}
