import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Setting.dart';
import '../../app_colors.dart';

const Color _kBrandGreen = Color(0xFF46AA57);

/// Account details from [UserProvider] (pushed from Settings).
class AccountDetailPage extends StatelessWidget {
  const AccountDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: _kBrandGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider up, _) {
          final User? u = up.currentUser;
          if (u == null) {
            return const Center(child: Text('No account loaded'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: _kBrandGreen.withValues(alpha: 0.15),
                  backgroundImage: u.customerImage,
                  child: u.customerImage == null
                      ? Text(
                          u.name.isNotEmpty
                              ? u.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: _kBrandGreen,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                u.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                u.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Profile editing and linked sign-in methods can ship in a later build.',
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _sessionReminders = true;
  bool _weeklySummary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: _kBrandGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  title: const Text(
                    'Focus session reminders',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Nudge before a scheduled session',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: _sessionReminders,
                  activeThumbColor: _kBrandGreen,
                  onChanged: (bool v) => setState(() => _sessionReminders = v),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                SwitchListTile(
                  title: const Text(
                    'Weekly summary',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'XP and streak highlights',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: _weeklySummary,
                  activeThumbColor: _kBrandGreen,
                  onChanged: (bool v) => setState(() => _weeklySummary = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'System permission for alerts is still required on device builds.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class ExportImportPage extends StatelessWidget {
  const ExportImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: _kBrandGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Export / import',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Back up your city layout and progress to a file, or restore from a backup. '
                  'File I/O will be wired when persistence is finalized.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export started')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: _kBrandGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Export backup', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Import started')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _kBrandGreen,
                side: BorderSide(color: _kBrandGreen.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Import backup', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareCityPage extends StatelessWidget {
  const ShareCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: _kBrandGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Share city',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Share a snapshot or invite friends to see your Focus City. '
                  'Native share sheet integration can be added for mobile.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share opened')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: _kBrandGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.ios_share_rounded),
              label: const Text('Share', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
