import 'dart:async';

import 'package:flutter/foundation.dart';
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

/// Run an async step but never let it crash app startup. A failing optional
/// service (audio background, notifications, locale data) should degrade
/// gracefully, not blank the whole app.
Future<void> _safe(String label, Future<void> Function() step) async {
  try {
    await step();
  } catch (e, st) {
    debugPrint('[init] "$label" failed: $e\n$st');
  }
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Surface framework errors to the console instead of a hard crash.
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('[FlutterError] ${details.exceptionAsString()}');
    };

    await _safe('orientation', () async {
      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]);
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Storage is the one hard requirement — if Hive fails the app can't work,
    // but we still try/catch so we at least reach runApp and show UI.
    await _safe('hive', () => Hive.initFlutter());
    await _safe('storage', () => StorageService.instance.init());
    await _safe('notifications', () => NotificationService.instance.init());
    await _safe('intl-ar', () => initializeDateFormatting('ar'));
    await _safe('intl-en', () => initializeDateFormatting('en'));

    // Background audio (mobile only). just_audio_background is mobile-only and
    // its init can throw on misconfiguration — never let that block boot.
    if (!kIsWeb) {
      await _safe('audio-background', () async {
        await JustAudioBackground.init(
          androidNotificationChannelId: 'app.noor.audio',
          androidNotificationChannelName: 'Noor — Quran Audio',
          androidNotificationOngoing: true,
          androidShowNotificationBadge: true,
        );
      });
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
  }, (Object error, StackTrace stack) {
    debugPrint('[zone] uncaught: $error\n$stack');
  });
}
