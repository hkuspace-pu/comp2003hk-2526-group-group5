import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/focus_session_provider.dart';
import '../../models/session_record.dart';
import 'widgets/stat_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Color themeGreen = AppColors.primaryGreen;

  @override
  Widget build(BuildContext context) {
    final focusProvider = Provider.of<FocusSessionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: themeGreen,
        title: const Text('Statistics & Activities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<FocusSessionRecord>>(
        stream: focusProvider.sessionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allRecords = snapshot.data ?? [];
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

          final dailyRecords = allRecords.where((s) => s.timestamp.isAfter(today)).toList();
          final weeklyRecords = allRecords.where((s) => s.timestamp.isAfter(startOfWeek)).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Summary Cards (Daily/Weekly)
                Row(
                  children: [
                    Expanded(child: SummaryCard(title: 'Daily', sessions: dailyRecords, themeGreen: themeGreen)),
                    const SizedBox(width: 12),
                    Expanded(child: SummaryCard(title: 'Weekly', sessions: weeklyRecords, themeGreen: themeGreen)),
                  ],
                ),
                const SizedBox(height: 16),

                // Weekly Bar Chart (Minutes)
                _buildWeeklyUsageChart(weeklyRecords),
                const SizedBox(height: 16),

                // Monthly Trend Chart (XP)
                _buildMonthlyTrendChart(allRecords),
                const SizedBox(height: 16),

                // Recent Activity List
                _buildRecentActivity(allRecords),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyUsageChart(List<FocusSessionRecord> sessions) {
    final Map<int, int> weekdayData = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    for (var s in sessions) {
      weekdayData[s.timestamp.weekday] = (weekdayData[s.timestamp.weekday] ?? 0) + s.durationMinutes;
    }

    return StatBaseCard(
      title: 'Weekly Focus Time (min)',
      child: SizedBox(
        height: 120,
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: weekdayData.entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [BarChartRodData(toY: e.value.toDouble(), color: themeGreen, width: 15, borderRadius: BorderRadius.circular(4))]
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendChart(List<FocusSessionRecord> sessions) {
    final now = DateTime.now();
    final monthly = sessions.where((s) => s.timestamp.month == now.month).toList();
    final totalXp = monthly.fold<int>(0, (prev, s) => prev + s.xpEarned);

    return StatBaseCard(
      title: 'Monthly XP Trend',
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: themeGreen,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: themeGreen.withValues(alpha:0.1)),
                    spots: _generateMonthlySpots(monthly),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monthly Total XP', style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('$totalXp XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<FocusSessionRecord> sessions) {
    return StatBaseCard(
      title: 'Recent Activity',
      child: Column(
        children: sessions.take(5).map((s) {
          final bool isFocus = s.type == 'Focus Session';
          final Color typeColor = isFocus ? themeGreen : Colors.orange;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: typeColor.withValues(alpha:0.1),
              child: Icon(isFocus ? Icons.timer : Icons.assignment, color: typeColor, size: 20),
            ),
            title: Text(isFocus ? '${s.durationMinutes}m Focus' : 'Offline Task',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('MM-dd HH:mm').format(s.timestamp), style: const TextStyle(fontSize: 11)),
            trailing: Text('+${s.xpEarned} XP', style: TextStyle(color: themeGreen, fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  List<FlSpot> _generateMonthlySpots(List<FocusSessionRecord> sessions) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month + 1, 0).day;
    Map<int, int> dailyXp = {for (int i = 1; i <= days; i++) i: 0};
    for (var s in sessions) {
      if (s.timestamp.month == now.month) {
        dailyXp[s.timestamp.day] = (dailyXp[s.timestamp.day] ?? 0) + s.xpEarned;
      }
    }
    return dailyXp.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
  }
}