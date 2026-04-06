import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/staff_provider.dart';
import 'staff_dashboard_screen.dart';
import 'staff_user_data_screen.dart';

/// Staff area: dashboard + user data (read-only demo over app data).
class StaffMainShell extends StatefulWidget {
  const StaffMainShell({super.key});

  @override
  State<StaffMainShell> createState() => _StaffMainShellState();
}

class _StaffMainShellState extends State<StaffMainShell> {
  int _index = 0;

  static const Color _accent = Color(0xFF2B579A);

  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>().currentStaff;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        title: const Text('Staff'),
        actions: [
          if (staff != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  staff.email,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<StaffProvider>().logout(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          StaffDashboardScreen(),
          StaffUserDataScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_shared_outlined),
            selectedIcon: Icon(Icons.folder_shared),
            label: 'User data',
          ),
        ],
      ),
    );
  }
}
