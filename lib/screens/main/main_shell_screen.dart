import 'package:flutter/material.dart';

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

  static const List<String> _titles = <String>[
    'Build Your City',
    'Mood log',
    'Dashboard',
    'Activity',
    'Settings',
  ];

  void _confirmLeaveToWelcome(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Leave app?'),
        content: const Text(
          'You will return to the welcome screen.',
        ),
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
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: kMainShellBackground,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(_titles[_index]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Back to welcome',
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
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.mood_outlined),
            selectedIcon: Icon(Icons.mood),
            label: 'Mood',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_run_outlined),
            selectedIcon: Icon(Icons.directions_run),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
