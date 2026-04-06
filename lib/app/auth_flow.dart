import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home.dart';
import '../Login.dart';
import '../Register.dart';
import '../staff/staff_login_screen.dart';
import '../staff/staff_welcome_screen.dart';

enum _AuthPage { welcome, login, register, staffWelcome, staffLogin }

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  _AuthPage _page = _AuthPage.welcome;

  @override
  Widget build(BuildContext context) {
    switch (_page) {
      case _AuthPage.welcome:
        return HomeScreen(
          onSignIn: () => setState(() => _page = _AuthPage.login),
          onSignUp: () => setState(() => _page = _AuthPage.register),
          onStaffPortal: () => setState(() => _page = _AuthPage.staffWelcome),
        );
      case _AuthPage.login:
        return LoginScreen(
          onBack: () => setState(() => _page = _AuthPage.welcome),
          onNavigateSignUp: () => setState(() => _page = _AuthPage.register),
        );
      case _AuthPage.register:
        return ChangeNotifierProvider<SignUpData>(
          create: (_) => SignUpData(),
          child: SignUpScreen(
            onBack: () => setState(() => _page = _AuthPage.welcome),
          ),
        );
      case _AuthPage.staffWelcome:
        return StaffWelcomeScreen(
          onContinueToLogin: () => setState(() => _page = _AuthPage.staffLogin),
          onBack: () => setState(() => _page = _AuthPage.welcome),
        );
      case _AuthPage.staffLogin:
        return StaffLoginScreen(
          onBack: () => setState(() => _page = _AuthPage.staffWelcome),
        );
    }
  }
}
