import 'package:flutter/material.dart';

import 'package:groupproject_group5/ui/focus_city_page.dart';
import 'package:groupproject_group5/ui/home_screen.dart';
import 'package:groupproject_group5/ui/mood_logging_page.dart';
import 'package:groupproject_group5/ui/settings_page.dart';

/// Root shell with [BottomNavigationBar] and tab bodies in an [IndexedStack].
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
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          MoodLoggingPage(embedInMainShell: true),
          FocusCityPage(),
          SettingsPage(embedInMainShell: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (int i) => setState(() => _index = i),
        selectedItemColor: _accent,
        unselectedItemColor: Colors.grey.shade700,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood_outlined),
            activeIcon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park_outlined),
            activeIcon: Icon(Icons.park),
            label: 'City',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
