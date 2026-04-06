import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:groupproject_group5/app/app_routes.dart';
import 'package:groupproject_group5/app/auth_flow.dart';
import 'package:groupproject_group5/core/app_theme.dart';
import 'package:groupproject_group5/l10n/locale_controller.dart';
import 'package:groupproject_group5/state/app_data_provider.dart';
import 'package:groupproject_group5/state/city_gamification_state.dart' as city;
import 'package:groupproject_group5/state/profile_auth_data.dart';
import 'package:groupproject_group5/state/profile_gamification_data.dart' as profile;
import 'package:groupproject_group5/state/sign_up_data.dart';
import 'package:groupproject_group5/state/staff_provider.dart';
import 'package:groupproject_group5/state/user_provider.dart';
import 'package:groupproject_group5/staff/staff_main_shell.dart';
import 'package:groupproject_group5/ui/login_screen.dart';
import 'package:groupproject_group5/ui/main_shell.dart' as ui;
import 'package:groupproject_group5/ui/register_screen.dart';
import 'package:groupproject_group5/ui/session_complete_screen.dart';
import 'package:groupproject_group5/ui/user_profile_screen.dart';

class FocusWellbeingApp extends StatelessWidget {
  const FocusWellbeingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => SignUpData()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()..init()),
        ChangeNotifierProvider<profile.GamificationData>(
          create: (_) => profile.GamificationData(),
        ),
        ChangeNotifierProvider<AuthData>(create: (_) => AuthData()),
        ChangeNotifierProvider<city.GamificationData>(
          create: (_) => city.GamificationData(),
        ),
        ChangeNotifierProvider<city.FocusSessionData>(
          create: (BuildContext context) {
            final city.GamificationData g =
                context.read<city.GamificationData>();
            return city.FocusSessionData(g);
          },
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'Focus Wellbeing',
            theme: buildAppTheme(),
            debugShowCheckedModeBanner: false,
            locale: locale.locale,
            supportedLocales: const [
              Locale('en'),
              Locale.fromSubtags(
                languageCode: 'zh',
                scriptCode: 'Hant',
                countryCode: 'HK',
              ),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const _RootGate(),
            routes: <String, WidgetBuilder>{
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const SignUpScreen(),
              AppRoutes.profile: (_) =>
                  const UserProfileScreen(embedInMainShell: true),
              AppRoutes.session: (_) =>
                  const SessionCompleteScreen(embedInMainShell: true),
            },
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
    return Consumer2<StaffProvider, UserProvider>(
      builder: (context, staff, userProvider, _) {
        if (staff.currentStaff != null) {
          return const StaffMainShell();
        }
        if (userProvider.currentUser == null) {
          return const AuthFlow();
        }
        return const ui.MainShell();
      },
    );
  }
}
