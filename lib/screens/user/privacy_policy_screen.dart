import 'package:flutter/material.dart';

/// Placeholder copy for sign-up flow (UI only).
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
              'Last updated (UI mock)',
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
                  'This is placeholder text for your course project. Replace '
                  'with real policy before release. We describe what data '
                  'the app would collect (account email, mood logs, focus '
                  'sessions) once backend features are enabled.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'How we use it',
              body:
                  'Placeholder: data would be used to show your dashboard, '
                  'sync across devices, and improve the experience. No '
                  'actual processing happens in UI-only builds.',
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
