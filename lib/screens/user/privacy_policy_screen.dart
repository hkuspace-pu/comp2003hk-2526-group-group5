import 'package:flutter/material.dart';

/// Privacy policy copy used by sign-up flow.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color _bg = Color(0xFFF8F8EC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Privacy policy'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: <Widget>[
            Text(
              'Last updated',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'What we collect',
              body:
                  'We collect information you provide in the app, such as '
                  'account email, mood logs, and focus session records, to '
                  'support core features and improve your experience.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'How we use it',
              body:
                  'Your data is used to show your dashboard, help sync your '
                  'experience across supported devices, and maintain app '
                  'features related to productivity and wellbeing.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Your choices',
              body:
                  'You can export or delete data from Settings when those '
                  'screens are wired. This page exists so the sign-up checkbox '
                  'has somewhere to link.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
