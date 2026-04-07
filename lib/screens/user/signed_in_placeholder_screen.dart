import 'package:flutter/material.dart';

/// UI only: temporary screen after Sign In / Sign Up until MainShell exists.
class SignedInPlaceholderScreen extends StatelessWidget {
  const SignedInPlaceholderScreen({super.key});

  static const Color _bg = Color(0xFFF8F8EC);

  void _backToWelcome(BuildContext context) {
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Signed in'),
        backgroundColor: _bg,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'You are in (UI mock)',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'No real sign-in yet — this screen is only for layout and '
                'navigation. Next: MainShell + BottomNavigationBar.',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _backToWelcome(context),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to welcome'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
