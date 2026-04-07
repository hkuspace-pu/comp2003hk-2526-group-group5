import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../app_colors.dart';
import '../../responsive_shell.dart';
import '../../Mood_Logging.dart';
import '../../Session_Activity.dart';
import '../../Setting.dart';
import 'dashboard_tab.dart';
import 'focus_city_tab.dart';

/// Main app shell with [NavigationBar] and tab bodies (UI).
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  void _confirmLeaveToWelcome(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.leaveAppTitle),
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
            child: Text(l10n.leaveAppButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<String> titles = <String>[
      l10n.shellTitleBuildCity,
      l10n.shellTitleMoodLog,
      l10n.dashboardLabel,
      l10n.shellTitleActivity,
      l10n.settingsLabel,
    ];
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: kMainShellBackground,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(titles[_index]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: l10n.backToWelcomeTooltip,
            onPressed: () => _confirmLeaveToWelcome(context),
          ),
        ],
      ),
      body: ResponsiveShellBody(
        child: IndexedStack(
          index: _index,
          children: const <Widget>[
            FocusCityTab(),
            MoodLoggingPage(embedded: true),
            DashboardTab(),
            SessionCompleteScreen(embedded: true),
            SettingsPage(embedded: true),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 62,
        backgroundColor: kMainShellBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        selectedIndex: _index,
        onDestinationSelected: (int i) => setState(() => _index = i),
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: l10n.tabFocus,
          ),
          NavigationDestination(
            icon: const Icon(Icons.mood_outlined),
            selectedIcon: const Icon(Icons.mood),
            label: l10n.tabMood,
          ),
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboardLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.directions_run_outlined),
            selectedIcon: const Icon(Icons.directions_run),
            label: l10n.tabActivity,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settingsLabel,
          ),
        ],
      ),
    );
  }
}
