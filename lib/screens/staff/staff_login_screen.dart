import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import 'staff_shell_screen.dart';
import 'staff_signup_screen.dart';
import 'staff_theme.dart';

/// Demo staff credentials (UI-only; same pattern as [Login.dart]).
const String kStaffDemoLoginEmail = 'staff@screen-time.app';
const String kStaffDemoLoginPassword = 'Staff1234!';

/// Staff login — navigates to [StaffShellScreen] on success (UI-only validation).
class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  static String _displayNameFromEmail(String email) {
    final String local = email.split('@').first.trim();
    if (local.isEmpty) return 'Staff';
    final String first = local.split(RegExp(r'[._-]')).first;
    if (first.isEmpty) return 'Staff';
    return '${first[0].toUpperCase()}${first.length > 1 ? first.substring(1) : ''}';
  }

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  void _submit() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgEnterWorkEmailPassword)),
      );
      return;
    }
    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgEnterValidEmail)),
      );
      return;
    }

    final String displayName = _displayNameFromEmail(email);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => StaffShellScreen(
          staffDisplayName: displayName,
          staffEmail: email,
        ),
      ),
    );
  }

  void _fillDemoAccount() {
    _emailController.text = kStaffDemoLoginEmail;
    _passwordController.text = kStaffDemoLoginPassword;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.msgEmailPasswordFilled)),
    );
  }

  void _signInWithDemoAccount() {
    _emailController.text = kStaffDemoLoginEmail;
    _passwordController.text = kStaffDemoLoginPassword;
    _submit();
  }

  void _openSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const StaffSignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: StaffTheme.background,
      appBar: AppBar(
        backgroundColor: StaffTheme.background,
        foregroundColor: StaffTheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.staffLoginTitle),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        l10n.staffWorkAccountTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: StaffTheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.staffWorkAccountHint,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: StaffTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: StaffTheme.primary.withValues(alpha: 0.35),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 22,
                                    color: Colors.grey.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.staffDemoAccountTitle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.staffDemoAccountHint,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const SelectableText(
                                'Email\n$kStaffDemoLoginEmail',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const SelectableText(
                                'Password\n$kStaffDemoLoginPassword',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.black87,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _fillDemoAccount,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: StaffTheme.primary,
                                        side: BorderSide(
                                          color: StaffTheme.primary.withValues(alpha: 0.85),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text(
                                        l10n.fillFields,
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: _signInWithDemoAccount,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: StaffTheme.primary,
                                        foregroundColor: StaffTheme.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text(
                                        l10n.quickSignIn,
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: l10n.staffWorkEmailLabel,
                          filled: true,
                          fillColor: StaffTheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.passwordLabel,
                          filled: true,
                          fillColor: StaffTheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: StaffTheme.primary,
                          foregroundColor: StaffTheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.continueLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _openSignUp,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: StaffTheme.primary,
                          side: BorderSide(
                            color: StaffTheme.primary.withValues(alpha: 0.6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.signUp,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
