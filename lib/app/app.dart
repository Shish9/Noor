import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/state/app_state.dart';
import '../core/state/settings_state.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/shell/app_shell.dart';
import 'router.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsState>();
    final AppState app = context.watch<AppState>();

    // Material doesn't ship Kurdish localizations, so map ckb/kmr to Arabic
    // for the Material/Cupertino layer (same RTL + Arabic-script behavior).
    // Our own Translations system + Directionality still drive every visible
    // UI string and the layout direction from `settings.language`.
    final Locale materialLocale = settings.language.code == 'en'
        ? const Locale('en')
        : const Locale('ar');

    return MaterialApp(
      title: 'Noor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      locale: materialLocale,
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: app.isFirstLaunch ? const OnboardingScreen() : const AppShell(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          // Force the directionality from the user's chosen language so RTL
          // languages (Arabic, Sorani, Badini) flip the entire layout.
          textDirection: settings.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
