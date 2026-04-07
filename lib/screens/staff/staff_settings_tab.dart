import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../main_shell_insets.dart';
import '../../widgets/language_switcher.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
            title: l10n.staffSettingsPreferences,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                leading: _LeadingIcon(icon: Icons.language_rounded),
                title: Text(
                  AppLocalizations.of(context)!.settingsLanguage,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.settingsLanguageSubtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                onTap: () => showAppLanguagePicker(context),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _notifications,
                activeThumbColor: StaffTheme.primary,
                title: Text(l10n.staffPushNotifications),
                subtitle: Text(l10n.staffPushNotificationsSubtitle),
                onChanged: (bool v) => setState(() => _notifications = v),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _weeklyDigest,
                activeThumbColor: StaffTheme.primary,
                title: Text(l10n.staffWeeklyDigestEmail),
                subtitle: Text(l10n.staffWeeklyDigestEmailSubtitle),
                onChanged: (bool v) => setState(() => _weeklyDigest = v),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                value: _compactRows,
                activeThumbColor: StaffTheme.primary,
                title: Text(l10n.staffCompactUserList),
                subtitle: Text(l10n.staffCompactUserListSubtitle),
                onChanged: (bool v) => setState(() => _compactRows = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.staffSupportSection,
            children: <Widget>[
              ListTile(
                leading: _LeadingIcon(icon: Icons.help_outline_rounded),
                title: Text(l10n.staffHelpCenter),
                subtitle: Text(l10n.staffHelpCenterSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack(l10n.staffHelpCenter),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: _LeadingIcon(icon: Icons.privacy_tip_outlined),
                title: Text(l10n.staffPrivacyDataPolicy),
                subtitle: Text(l10n.staffPrivacyDataPolicySubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack(l10n.staffPrivacyDataPolicy),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: _LeadingIcon(icon: Icons.mail_outline_rounded),
                title: Text(l10n.staffContactAdministrator),
                subtitle: Text(l10n.staffContactAdministratorSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _snack(l10n.staffContactAdministrator),
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
            label: Text(
              l10n.signOutLabel,
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
                    AppLocalizations.of(context)!.staffRoleLabel,
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
