import 'package:flutter/material.dart';

import '../../responsive_shell.dart';
import 'staff_dashboard_tab.dart';
import 'staff_settings_tab.dart';
import 'staff_theme.dart';
import 'staff_user_list_tab.dart';

/// Staff shell: overview + user directory (專員專用).
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

  static const List<String> _titles = <String>[
    'Staff overview',
    'User directory',
    'Settings',
  ];

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will return to the welcome screen.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
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
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(_titles[_index]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Sign out',
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
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline_rounded),
              selectedIcon: Icon(Icons.people),
              label: 'Users',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
