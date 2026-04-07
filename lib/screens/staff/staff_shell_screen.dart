import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../responsive_shell.dart';
import 'staff_dashboard_tab.dart';
import 'staff_settings_tab.dart';
import 'staff_theme.dart';
import 'staff_user_list_tab.dart';

/// Staff shell: overview + user directory (員工專用).
class StaffShellScreen extends StatefulWidget {
  const StaffShellScreen({
    super.key,
    required this.staffDisplayName,
    required this.staffEmail,
  });

  final String staffDisplayName;
  final String staffEmail;

  @override
  State<StaffShellScreen> createState() => _StaffShellScreenState();
}

class _StaffShellScreenState extends State<StaffShellScreen> {
  int _index = 0;

  void _confirmSignOut(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
            },
            style: FilledButton.styleFrom(
              backgroundColor: StaffTheme.primary,
              foregroundColor: StaffTheme.onPrimary,
            ),
            child: Text(l10n.signOutLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<String> titles = <String>[
      l10n.staffOverviewTitle,
      l10n.staffUserDirectoryTitle,
      l10n.settingsLabel,
    ];
    final ThemeData base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: StaffTheme.primary,
          secondary: StaffTheme.accent,
        ),
      ),
      child: Scaffold(
        backgroundColor: StaffTheme.background,
        appBar: AppBar(
          backgroundColor: StaffTheme.background,
          foregroundColor: StaffTheme.primary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(titles[_index]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: l10n.signOutLabel,
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
        body: ResponsiveShellBody(
          child: IndexedStack(
            index: _index,
            children: <Widget>[
              StaffDashboardTab(
                staffDisplayName: widget.staffDisplayName,
                staffEmail: widget.staffEmail,
              ),
              const StaffUserListTab(),
              StaffSettingsTab(
                staffDisplayName: widget.staffDisplayName,
                staffEmail: widget.staffEmail,
                onSignOutRequested: () => _confirmSignOut(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 62,
          backgroundColor: StaffTheme.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          indicatorColor: StaffTheme.primary.withValues(alpha: 0.12),
          selectedIndex: _index,
          onDestinationSelected: (int i) => setState(() => _index = i),
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: l10n.dashboardLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline_rounded),
              selectedIcon: const Icon(Icons.people),
              label: l10n.usersLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.settingsLabel,
            ),
          ],
        ),
      ),
    );
  }
}
