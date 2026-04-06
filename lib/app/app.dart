import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groupproject_group5/core/app_theme.dart';
import 'package:groupproject_group5/state/city_gamification_state.dart' as city;
import 'package:groupproject_group5/state/profile_auth_data.dart';
import 'package:groupproject_group5/state/profile_gamification_data.dart' as profile;
import 'package:groupproject_group5/state/sign_up_data.dart';
import 'package:groupproject_group5/state/user_provider.dart';
import 'package:groupproject_group5/ui/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpData>(create: (_) => SignUpData()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
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
      child: MaterialApp(
        title: 'Focus App',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const LoginScreen(),
      ),
    );
  }
}
