import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/state/app_state.dart';
import 'core/state/audio_state.dart';
import 'core/state/quran_state.dart';
import 'core/state/settings_state.dart';
import 'core/state/tafsir_state.dart';

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

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()..bootstrap()),
        ChangeNotifierProvider<SettingsState>(create: (_) => SettingsState()..load()),
        ChangeNotifierProvider<QuranState>(create: (_) => QuranState()..load()),
        ChangeNotifierProvider<TafsirState>(create: (_) => TafsirState()),
        ChangeNotifierProvider<AudioState>(create: (_) => AudioState()),
      ],
      child: const QuranApp(),
    ),
  );
}
