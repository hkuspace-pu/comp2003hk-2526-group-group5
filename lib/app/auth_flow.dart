import 'package:flutter/material.dart';

import 'package:groupproject_group5/staff/staff_login_screen.dart';
import 'package:groupproject_group5/staff/staff_welcome_screen.dart';
import 'package:groupproject_group5/ui/home_screen.dart';
import 'package:groupproject_group5/ui/login_screen.dart';
import 'package:groupproject_group5/ui/register_screen.dart';

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
        return SignUpScreen(
          onBack: () => setState(() => _page = _AuthPage.welcome),
          onNavigateLogin: () => setState(() => _page = _AuthPage.login),
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
