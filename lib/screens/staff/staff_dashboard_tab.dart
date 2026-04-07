import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../main_shell_insets.dart';
import 'staff_theme.dart';
import 'staff_end_user.dart';
import 'staff_sample_users.dart';

/// Staff overview: aggregate metrics and weekly trend (sample data).
class StaffDashboardTab extends StatelessWidget {
  const StaffDashboardTab({
    super.key,
    required this.staffDisplayName,
    required this.staffEmail,
  });

  final String staffDisplayName;
  final String staffEmail;

  static final List<double> _weekAggregateMinutes = <double>[
    120,
    95,
    140,
    88,
    160,
    72,
    110,
  ];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<String> dayLabels =
        l10n.weekChartDayLabels.split(',').map((String s) => s.trim()).toList();
    final List<StaffEndUser> users = staffSampleEndUsers();
    final int totalUsers = users.length;
    final int activeUsers =
        users.where((StaffEndUser u) => u.statusLabel == 'Active').length;
    final int totalFocusWeek =
        users.fold<int>(0, (int a, StaffEndUser u) => a + u.focusMinutesThisWeek);

    final double maxY = _weekAggregateMinutes.reduce(
          (double a, double b) => a > b ? a : b,
        ) +
        40;

    return ColoredBox(
      color: StaffTheme.background,
      child: ListView(
        padding: kMainTabScrollPadding,
        children: <Widget>[
          Card(
            elevation: 0,
            color: StaffTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.staffHelloName(staffDisplayName),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: StaffTheme.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    staffEmail,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.staffOverviewIntro,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.staffOverviewSection,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: StaffTheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  label: l10n.staffRegistered,
                  value: '$totalUsers',
                  icon: Icons.people_outline_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: l10n.staffActiveStatus,
                  value: '$activeUsers',
                  icon: Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _StatCard(
            label: l10n.staffFocusMinutesCohortWeek,
            value: '$totalFocusWeek',
            icon: Icons.timer_outlined,
            wide: true,
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: StaffTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      l10n.staffAllUsersChartTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 5,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: maxY / 5,
                              getTitlesWidget: (double v, _) => Text(
                                v.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double v, _) {
                                final int i = v.toInt();
                                if (i < 0 || i >= dayLabels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    dayLabels[i],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List<BarChartGroupData>.generate(
                          _weekAggregateMinutes.length,
                          (int i) => BarChartGroupData(
                            x: i,
                            barRods: <BarChartRodData>[
                              BarChartRodData(
                                toY: _weekAggregateMinutes[i],
                                width: 14,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                                color: StaffTheme.accent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.wide = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final Widget inner = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
            wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: StaffTheme.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: StaffTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: wide ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.25,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 0,
      color: StaffTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: wide ? inner : Center(child: inner),
    );
  }
}
