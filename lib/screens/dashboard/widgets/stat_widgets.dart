import 'package:flutter/material.dart';
import '../../../models/session_record.dart';

class StatBaseCard extends StatelessWidget {
  final String title;
  final Widget child;
  const StatBaseCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final List<FocusSessionRecord> sessions;
  final Color themeGreen;

  const SummaryCard({super.key, required this.title, required this.sessions, required this.themeGreen});

  @override
  Widget build(BuildContext context) {
    final int totalXp = sessions.fold<int>(0, (prev, s) => prev + s.xpEarned);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text('$totalXp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeGreen)),
            const Text('XP Total', style: TextStyle(fontSize: 10, color: Colors.grey)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Count', style: TextStyle(color: Colors.grey, fontSize: 13)),
                Text('${sessions.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}