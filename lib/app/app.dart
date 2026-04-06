import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Gamification.dart';
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
      child: MaterialApp(
        title: 'Focus Wellbeing',
        theme: buildTheme(),
        debugShowCheckedModeBanner: false,
        home: const _RootGate(),
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
