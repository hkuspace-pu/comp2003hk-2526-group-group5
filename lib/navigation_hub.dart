import 'package:flutter/material.dart';

import 'screens/gamification/focus_city_page.dart';
import 'screens/dashboard/statistics_screen.dart';
import 'screens/activity/session_complete_screen.dart';
import 'screens/settings/settings_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FocusCityPage(),         /// index 0: Home
    const SessionCompleteScreen(), /// index 1: Activity
    const StatisticsScreen(),      /// index 2: Stats
    const SettingsPage(),          /// index 3: Setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF46AA57), // 你的主題綠色
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem('images/home_icon.png', 'Home'),
          _buildNavItem('images/activity_icon.png', 'Activity'),
          _buildNavItem('images/dashboard_icon.png', 'Stats'),
          _buildNavItem('images/setting_icon.png', 'Setting'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(iconPath, width: 24, height: 24),
      activeIcon: Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: const Color(0xFF46AA57),
      ),
      label: label,
    );
  }
}