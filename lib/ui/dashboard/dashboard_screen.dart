import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groupproject_group5/l10n/locale_controller.dart';
import 'package:groupproject_group5/state/app_data_provider.dart';
import 'package:groupproject_group5/state/city_gamification_state.dart' as city;

/// Dashboard with sample stats and calendar markers.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _range = 0; // 0 day 1 week 2 month

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF46AA57);
    final tr = context.watch<LocaleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F4),
      appBar: AppBar(
        backgroundColor: accent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          tr.dashTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ToggleButtons(
            isSelected: [_range == 0, _range == 1, _range == 2],
            onPressed: (i) => setState(() => _range = i),
            borderRadius: BorderRadius.circular(12),
            selectedColor: Colors.white,
            fillColor: accent,
            color: accent,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(tr.dashToday),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(tr.dashWeek),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(tr.dashMonth),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer2<AppDataProvider, city.GamificationData>(
            builder: (context, data, game, _) {
              final n = data.sessions.length;
              final mockFocus = n * 12 + 18;
              final mockMood = data.moods.isEmpty ? '—' : '${(data.moods.first.moodIndex + 1)}/5';
              return Column(
                children: [
                  _StatCard(
                    icon: Icons.self_improvement,
                    title: tr.dashFocusPreview,
                    value: '$mockFocus ${tr.dashMinutes}',
                    subtitle: '${data.sessions.length} ${tr.dashSessionsStored}',
                    color: accent,
                  ),
                  const SizedBox(height: 12),
                  _StatCard(
                    icon: Icons.mood,
                    title: tr.dashMoodPreview,
                    value: mockMood,
                    subtitle: '${data.moods.length} ${tr.dashMoodRecords}',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _StatCard(
                    icon: Icons.military_tech,
                    title: tr.dashGamification,
                    value: 'Lv ${game.currentCurrentLevel}',
                    subtitle: 'XP ${game.currentTotalXp}',
                    color: Colors.deepOrange,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            tr.dashCalendarHint,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Consumer<AppDataProvider>(
            builder: (context, data, _) {
              final now = DateTime.now();
              return _MiniCalendarStrip(
                month: DateTime(now.year, now.month),
                hasLog: data.hasLogsOn,
                weekdayLabels: tr.calendarWeekdayLabels,
                monthTitle: tr.calendarMonthTitle(now.year, now.month),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniCalendarStrip extends StatelessWidget {
  const _MiniCalendarStrip({
    required this.month,
    required this.hasLog,
    required this.weekdayLabels,
    required this.monthTitle,
  });

  final DateTime month;
  final bool Function(DateTime day) hasLog;
  final List<String> weekdayLabels;
  final String monthTitle;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = first.weekday % 7;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final w in weekdayLabels)
                  Text(w, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.1,
              ),
              itemCount: startWeekday + daysInMonth,
              itemBuilder: (context, i) {
                if (i < startWeekday) return const SizedBox.shrink();
                final day = i - startWeekday + 1;
                final d = DateTime(month.year, month.month, day);
                final dot = hasLog(d);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$day', style: const TextStyle(fontSize: 12)),
                    if (dot)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF46AA57),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
