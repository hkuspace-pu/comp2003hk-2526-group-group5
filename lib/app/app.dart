import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../Gamification.dart';
import '../l10n/locale_controller.dart';
import '../state/app_data_provider.dart';
import '../state/user_provider.dart';
import 'auth_flow.dart';
import 'main_shell.dart';

class FocusWellbeingApp extends StatelessWidget {
  const FocusWellbeingApp({super.key});

  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF46AA57),
        primary: const Color(0xFF46AA57),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()..init()),
        ChangeNotifierProvider(create: (_) => GamificationData()),
        ChangeNotifierProvider<FocusSessionData>(
          create: (context) {
            final gamification =
                Provider.of<GamificationData>(context, listen: false);
            final data = Provider.of<AppDataProvider>(context, listen: false);
            return FocusSessionData(gamification, data);
          },
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'Focus Wellbeing',
            theme: buildTheme(),
            debugShowCheckedModeBanner: false,
            locale: locale.locale,
            supportedLocales: const [
              Locale('en'),
              Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const _RootGate(),
          );
        },
      ),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.currentUser == null) {
          return const AuthFlow();
        }
        return const MainShell();
      },
    );
  }
}
