import 'package:flutter/material.dart';

import '../../main_shell_insets.dart';
import 'staff_theme.dart';

class StaffSettingsTab extends StatefulWidget {
  const StaffSettingsTab({
    super.key,
    required this.staffDisplayName,
    required this.staffEmail,
    required this.onSignOutRequested,
  });

  final String staffDisplayName;
  final String staffEmail;
  final VoidCallback onSignOutRequested;

  @override
  State<StaffSettingsTab> createState() => _StaffSettingsTabState();
}

class _StaffSettingsTabState extends State<StaffSettingsTab> {
  bool _notifications = true;
  bool _weeklyDigest = true;
  bool _compactRows = false;

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: StaffTheme.background,
      child: ListView(
        padding: kMainTabScrollPadding,
        children: <Widget>[
          _AccountCard(
            staffDisplayName: widget.staffDisplayName,
            staffEmail: widget.staffEmail,
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Preferences',
            children: <Widget>[
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _notifications,
                activeColor: StaffTheme.primary,
                title: const Text('Push notifications'),
                subtitle: const Text('Receive account and system alerts.'),
                onChanged: (bool v) => setState(() => _notifications = v),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _weeklyDigest,
                activeColor: StaffTheme.primary,
                title: const Text('Weekly digest email'),
                subtitle: const Text('Summary of user activity and trends.'),
                onChanged: (bool v) => setState(() => _weeklyDigest = v),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _compactRows,
                activeColor: StaffTheme.primary,
                title: const Text('Compact user list'),
                subtitle: const Text('Display denser rows in User directory.'),
                onChanged: (bool v) => setState(() => _compactRows = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Support',
            children: <Widget>[
              ListTile(
                leading: _LeadingIcon(icon: Icons.help_outline_rounded),
                title: const Text('Help center'),
                subtitle: const Text('Guides for Staff workflows.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack('Help center'),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: _LeadingIcon(icon: Icons.privacy_tip_outlined),
                title: const Text('Privacy & data policy'),
                subtitle: const Text('Review data handling and access scope.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack('Privacy & data policy'),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: _LeadingIcon(icon: Icons.mail_outline_rounded),
                title: const Text('Contact administrator'),
                subtitle: const Text('Report access or data issues.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack('Contact administrator'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: widget.onSignOutRequested,
            style: FilledButton.styleFrom(
              backgroundColor: StaffTheme.primary,
              foregroundColor: StaffTheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text(
              'Sign out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.staffDisplayName,
    required this.staffEmail,
  });

  final String staffDisplayName;
  final String staffEmail;

  @override
  Widget build(BuildContext context) {
    final String initial = staffDisplayName.isNotEmpty
        ? staffDisplayName[0].toUpperCase()
        : 'S';
    return Card(
      elevation: 0,
      color: StaffTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundColor: StaffTheme.primary.withValues(alpha: 0.12),
              foregroundColor: StaffTheme.primary,
              child: Text(
                initial,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    staffDisplayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    staffEmail,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Role: Staff',
                    style: TextStyle(
                      fontSize: 12,
                      color: StaffTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: StaffTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: StaffTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 18, color: StaffTheme.primary),
    );
  }
}
