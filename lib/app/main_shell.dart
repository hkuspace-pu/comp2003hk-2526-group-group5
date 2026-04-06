import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Gamification.dart';
import '../l10n/locale_controller.dart';
import '../Mood_Logging.dart';
import '../Setting.dart';
import '../ui/activity/activity_demo_screen.dart';
import '../ui/dashboard/dashboard_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const Color _accent = Color(0xFF46AA57);

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleController>();
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          FocusCityPage(),
          MoodLoggingPage(),
          DashboardScreen(),
          ActivityDemoScreen(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        selectedItemColor: _accent,
        unselectedItemColor: Colors.grey.shade600,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.park), label: tr.navFocus),
          BottomNavigationBarItem(icon: const Icon(Icons.mood), label: tr.navMood),
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: tr.navDashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.list_alt), label: tr.navActivity),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: tr.navSettings),
        ],
      ),
    );
  }
}
