import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/state/app_state.dart';
import 'core/state/audio_state.dart';
import 'core/state/quran_state.dart';
import 'core/state/settings_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await Hive.initFlutter();
  await StorageService.instance.init();
  await NotificationService.instance.init();
  // Initialize Arabic + English date/time symbols so DateFormat('...', 'ar')
  // returns Arabic weekday + month names ("الإثنين · ١٣ مايو") instead of
  // crashing with a LocaleDataException.
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');

  // Initialize background audio so Quran recitation continues when the
  // app is in the background or the screen is locked. The notification
  // channel + media controls are wired up automatically.
  // Skipped on web — just_audio_background is mobile-only and would
  // otherwise crash boot before runApp() ever runs.
  if (!kIsWeb) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'app.noor.audio',
      androidNotificationChannelName: 'Noor — Quran Audio',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    );
  }

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()..bootstrap()),
        ChangeNotifierProvider<SettingsState>(create: (_) => SettingsState()..load()),
        ChangeNotifierProvider<QuranState>(create: (_) => QuranState()..load()),
        ChangeNotifierProvider<AudioState>(create: (_) => AudioState()),
      ],
      child: const QuranApp(),
    ),
  );
}
