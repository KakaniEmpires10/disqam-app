import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/reading_store.dart';
import 'services/participant_api.dart';
import 'services/participant_store.dart';
import 'services/admin_api.dart';
import 'services/admin_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: const Color(0xFFF8FBFC),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  const apiUrl = String.fromEnvironment('DISQAM_API_URL');
  runApp(
    DisqamApp(
      store: ReadingStore(),
      participants: ParticipantStore(
        api: HttpParticipantGateway(baseUrl: apiUrl),
      ),
      admin: AdminStore(api: HttpAdminGateway(baseUrl: apiUrl)),
    ),
  );
}
