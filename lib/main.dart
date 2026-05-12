import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Gamification.dart';
import 'Setting.dart';
import 'firebase_options.dart';
import 'locale_controller.dart';
import 'screens/user/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final Locale startLocale = await LocaleController.loadSavedLocale();
  runApp(MyApp(initialLocale: startLocale));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialLocale});

  final Locale initialLocale;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController(initialLocale),
        ),
        ChangeNotifierProvider<GamificationData>(
          create: (_) => GamificationData(),
        ),
        ChangeNotifierProvider<FocusSessionData>(
          create: (BuildContext context) => FocusSessionData(
            Provider.of<GamificationData>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (BuildContext context, LocaleController loc, _) {
          return MaterialApp(
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)?.appTitle ?? 'Screen time',
            debugShowCheckedModeBanner: false,
            locale: loc.locale,
            supportedLocales: const <Locale>[
              Locale('en'),
              Locale('zh', 'HK'),
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                  .copyWith(secondary: const Color(0xFF46AA57)),
            ),
            home: const UserWelcomeScreen(),
          );
        },
      ),
    );
  }
}
