import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Login.dart';
import '../../Register.dart';

const Color _kWelcomeBg = Color(0xFFF8F8EC);
const Color _kAccentGreen = Color(0xFF46AA57);
const Color _kTitleBlue = Color(0xFF1E73BE);

/// Part 1 / 10 — User flow: welcome landing before Sign In / Sign Up.
class UserWelcomeScreen extends StatelessWidget {
  const UserWelcomeScreen({super.key});

  void _openSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  void _openSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeNotifierProvider<SignUpData>(
          create: (_) => SignUpData(),
          child: const SignUpScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _kWelcomeBg,
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
                        'Welcome',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grow your focus. Build your city.',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                        child: Container(
                          width: 188,
                          height: 188,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'images/home_city_image.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => ColoredBox(
                                color: _kTitleBlue.withValues(alpha: 0.12),
                                child: const Icon(
                                  Icons.location_city_rounded,
                                  size: 72,
                                  color: _kTitleBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Screen time: Build your city',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _kTitleBlue,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Bullet(
                        icon: Icons.timer_outlined,
                        text: 'Stay on task with focus sessions',
                      ),
                      const SizedBox(height: 10),
                      _Bullet(
                        icon: Icons.mood_outlined,
                        text: 'Log mood and see your patterns',
                      ),
                      const SizedBox(height: 10),
                      _Bullet(
                        icon: Icons.dashboard_customize_outlined,
                        text: 'Track progress on your dashboard',
                      ),
                      const Spacer(),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 54,
                        child: FilledButton(
                          onPressed: () => _openSignIn(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: _kAccentGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: _kAccentGreen.withValues(alpha: 0.45),
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
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () => _openSignUp(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: _kAccentGreen,
                              width: 2,
                            ),
                            foregroundColor: _kAccentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'New here? Create an account to save your city and stats.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.black45,
                          height: 1.35,
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
          color: _kAccentGreen.withValues(alpha: 0.9),
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
