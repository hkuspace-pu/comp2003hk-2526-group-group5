import 'package:flutter/material.dart';

/// Main app shell with [NavigationBar]; each tab is a placeholder until real screens are added.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  static const List<String> _titles = <String>[
    'Focus',
    'Mood log',
    'Dashboard',
    'Activity',
    'Settings',
  ];

  void _confirmLeaveToWelcome(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Leave app preview?'),
        content: const Text(
          'You will return to the welcome screen. (UI only — no sign-out API.)',
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
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Back to welcome',
            onPressed: () => _confirmLeaveToWelcome(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const <Widget>[
          _TabPlaceholder(
            icon: Icons.timer_outlined,
            title: 'Focus',
            hint: 'Timer and resume state — coming next.',
          ),
          _TabPlaceholder(
            icon: Icons.mood_outlined,
            title: 'Mood log',
            hint: 'Logging UI — coming next.',
          ),
          _TabPlaceholder(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            hint: 'Charts and summary — coming next.',
          ),
          _TabPlaceholder(
            icon: Icons.directions_run_outlined,
            title: 'Activity',
            hint: 'Activity list and share — coming next.',
          ),
          _TabPlaceholder(
            icon: Icons.settings_outlined,
            title: 'Settings',
            hint: 'Account, notifications, export — coming next.',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
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
            label: 'Dash',
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

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({
    required this.icon,
    required this.title,
    required this.hint,
  });

  final IconData icon;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: const Color(0xFFF8F8EC),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 64, color: scheme.primary.withValues(alpha: 0.85)),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                hint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
