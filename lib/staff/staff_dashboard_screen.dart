import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_data_provider.dart';

/// Staff overview: aggregate counts from in-memory app data (demo).
class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  static const Color _accent = Color(0xFF2B579A);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, data, _) {
        final nSessions = data.sessions.length;
        final nMoods = data.moods.length;
        final nActivities = data.activities.length;
        final nProfiles = data.profiles.length;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aggregated wellbeing metrics from synced demo data.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    label: 'Profiles',
                    value: '$nProfiles',
                    icon: Icons.group_outlined,
                    color: _accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    label: 'Focus sessions',
                    value: '$nSessions',
                    icon: Icons.timer_outlined,
                    color: const Color(0xFF46AA57),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    label: 'Mood logs',
                    value: '$nMoods',
                    icon: Icons.mood,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    label: 'Activities',
                    value: '$nActivities',
                    icon: Icons.list_alt,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Quick notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Data is stored in-memory for this build. Connect Firestore / '
                  'admin APIs to list real users and export reports.',
                  style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
