import 'package:flutter/material.dart';

import 'staff_login_screen.dart';
import 'staff_signup_screen.dart';
import 'staff_theme.dart';

/// Entry screen for Staff (專員) — separate from the student welcome flow.
class StaffWelcomeScreen extends StatelessWidget {
  const StaffWelcomeScreen({super.key});

  void _openStaffLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const StaffLoginScreen(),
      ),
    );
  }

  void _openStaffSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const StaffSignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: StaffTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 24),
                      Text(
                        'Staff portal',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: StaffTheme.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '專員專用 · 管理與檢視使用者資料',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          color: StaffTheme.primary.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in with your staff account to open the dashboard and user directory.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: StaffTheme.primary.withValues(alpha: 0.08),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: StaffTheme.primary.withValues(alpha: 0.12),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 72,
                            color: StaffTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Bullet(
                        icon: Icons.dashboard_customize_outlined,
                        text: 'Overview: engagement and focus trends',
                      ),
                      const SizedBox(height: 10),
                      _Bullet(
                        icon: Icons.groups_outlined,
                        text: 'User directory: search and open profiles',
                      ),
                      const SizedBox(height: 10),
                      _Bullet(
                        icon: Icons.lock_outline_rounded,
                        text: 'Restricted to authorised staff accounts',
                      ),
                      const Spacer(),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 54,
                        child: FilledButton(
                          onPressed: () => _openStaffLogin(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: StaffTheme.primary,
                            foregroundColor: StaffTheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: StaffTheme.primary.withValues(alpha: 0.35),
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => _openStaffSignUp(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: StaffTheme.primary,
                            side: BorderSide(
                              color: StaffTheme.primary.withValues(alpha: 0.65),
                              width: 1.6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(
                          'Back to student app',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: StaffTheme.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 22,
          color: StaffTheme.primary.withValues(alpha: 0.85),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.35,
                ),
          ),
        ),
      ],
    );
  }
}
