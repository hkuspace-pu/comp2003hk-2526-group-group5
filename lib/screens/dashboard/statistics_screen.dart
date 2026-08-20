import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/focus_session_provider.dart';
import '../../models/session_record.dart';
import '../../services/firestore_service.dart';
import 'widgets/stat_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Color themeGreen = AppColors.primaryGreen;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final focusProvider = Provider.of<FocusSessionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: themeGreen,
        title: const Text('Statistics & Activities',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Summary Cards
                Row(
                  children: [
                    Expanded(child: SummaryCard(title: 'Daily', sessions: dailyRecords, themeGreen: themeGreen)),
                    const SizedBox(width: 12),
                    Expanded(child: SummaryCard(title: 'Weekly', sessions: weeklyRecords, themeGreen: themeGreen)),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Weekly Focus & Monthly XP
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildSmallBarChart(weeklyRecords)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSmallLineChart(allRecords)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Dynamic Mood Trend
                const Text(
                  "Weekly Mood Trend",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _firestoreService.getMoodLogsStream(),
                  builder: (context, moodSnapshot) {
                    if (!moodSnapshot.hasData) return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
                    return _buildMoodTrendChart(moodSnapshot.data!);
                  },
                ),

                const SizedBox(height: 20),

                // 4. Recent Activity
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRecentActivity(allRecords),
              ],
            ),
          );
        },
      ),
    );
  }

  // Weekly Focus Bar Chart
  Widget _buildSmallBarChart(List<FocusSessionRecord> sessions) {
    final Map<int, int> weekdayData = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    for (var s in sessions) {
      weekdayData[s.timestamp.weekday] = (weekdayData[s.timestamp.weekday] ?? 0) + s.durationMinutes;
    }

    return StatBaseCard(
      title: 'Weekly Focus',
      child: SizedBox(
        height: 120,
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) => Text('${value.toInt()}m', style: const TextStyle(fontSize: 8, color: Colors.grey)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    int idx = value.toInt() - 1;
                    if (idx >= 0 && idx < days.length) {
                      return Text(days[idx], style: const TextStyle(fontSize: 9, color: Colors.grey));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            barGroups: weekdayData.entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: e.value.toDouble(), color: themeGreen, width: 6, borderRadius: BorderRadius.circular(2))
                ]
            )).toList(),
          ),
        ),
      ),
    );
  }

  // Monthly XP Line Chart
  Widget _buildSmallLineChart(List<FocusSessionRecord> sessions) {
    final now = DateTime.now();
    final monthly = sessions.where((s) => s.timestamp.month == now.month).toList();

    return StatBaseCard(
      title: 'Monthly XP',
      child: SizedBox(
        height: 120,
        child: LineChart(
          LineChartData(
            minY: -5,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {

                    if (value < 0) return const SizedBox();
                    return Text('${value.toInt()}', style: const TextStyle(fontSize: 8, color: Colors.grey));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 7,
                  getTitlesWidget: (value, meta) {
                    int val = value.toInt();
                    if (val <= 0) return const SizedBox();
                    return Text('${val}d', style: const TextStyle(fontSize: 8, color: Colors.grey));
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: themeGreen,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, color: themeGreen.withOpacity(0.1)),
                spots: _generateMonthlySpots(monthly),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Weekly Mood Trend Chart
  Widget _buildMoodTrendChart(List<Map<String, dynamic>> moodData) {
    final List<IconData> moodIcons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    final List<Color> moodColors = [
      Colors.red,
      Colors.deepOrange,
      Colors.yellow.shade700,
      Colors.lightGreen,
      Colors.green,
    ];

    Map<int, double> weeklySpotsMap = {};
    for (var log in moodData) {
      DateTime date = (log['timestamp'] as Timestamp).toDate();
      int weekdayIndex = date.weekday - 1;
      double score = (log['moodIndex'] ?? 2).toDouble();

      if (!weeklySpotsMap.containsKey(weekdayIndex)) {
        weeklySpotsMap[weekdayIndex] = score;
      }
    }

    List<FlSpot> spots = weeklySpotsMap.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return StatBaseCard(
      title: '',
      child: SizedBox(
        height: 190,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 6,
            minY: -0.4,
            maxY: 4.4,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (value, meta) {

                    final intVal = value.round();
                    if ((value - intVal).abs() > 0.05) return const SizedBox();

                    if (intVal >= 0 && intVal < moodIcons.length) {
                      return Center(
                        child: Icon(moodIcons[intVal], color: moodColors[intVal], size: 20),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    int index = value.toInt();
                    if (index >= 0 && index < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          days[index],
                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: themeGreen,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: themeGreen.withValues(alpha: 0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<FocusSessionRecord> sessions) {
    return Column(
      children: sessions.take(5).map((s) {
        final bool isFocus = s.type == 'Focus Session';
        final Color typeColor = isFocus ? themeGreen : Colors.orange;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: typeColor.withOpacity(0.1),
              child: Icon(isFocus ? Icons.timer : Icons.assignment, color: typeColor, size: 20),
            ),
            title: Text(isFocus ? '${s.durationMinutes}m Focus' : 'Offline Task',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('MM-dd HH:mm').format(s.timestamp), style: const TextStyle(fontSize: 11)),
            trailing: Text('+${s.xpEarned} XP', style: TextStyle(color: themeGreen, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
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