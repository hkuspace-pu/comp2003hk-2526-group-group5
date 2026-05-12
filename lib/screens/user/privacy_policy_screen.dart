import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

/// Privacy policy copy used by sign-up flow.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color _bg = Color(0xFFF8F8EC);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(l10n.privacyPolicyTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: <Widget>[
            Text(
              l10n.lastUpdatedLabel,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: l10n.privacyWhatWeCollectTitle,
              body: l10n.privacyWhatWeCollectBody,
            ),
            const SizedBox(height: 20),
            _Section(
              title: l10n.privacyHowWeUseItTitle,
              body: l10n.privacyHowWeUseItBody,
            ),
            const SizedBox(height: 20),
            _Section(
              title: l10n.privacyYourChoicesTitle,
              body: l10n.privacyYourChoicesBody,
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
