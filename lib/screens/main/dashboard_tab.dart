import 'package:fl_chart/fl_chart.dart';

import '../../app_colors.dart';
import '../../gamification_l10n.dart';
import '../../main_shell_insets.dart';
import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../Gamification.dart';

/// Progress, Today / Week summary, Material calendar, and per-day demo stats.
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  static final List<double> _mockWeekMinutes = <double>[20, 35, 15, 40, 28, 50, 32];

  /// 0 = Today, 1 = Week
  int _periodIndex = 0;
  DateTime _selectedCalendarDay = _dateOnly(DateTime.now());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: kMainShellBackground,
      child: ListView(
        padding: kMainTabScrollPadding,
        children: <Widget>[
          Consumer<GamificationData>(
            builder: (BuildContext context, GamificationData g, _) {
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.yourProgress,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          _StatChip(
                            label: l10n.levelLabel,
                            value: '${g.currentCurrentLevel}',
                          ),
                          const SizedBox(width: 12),
                          _StatChip(
                            label: l10n.totalXpLabel,
                            value: '${g.currentTotalXp}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        localizedNextUnlockProgress(g, l10n),
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.overviewLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SegmentedButton<int>(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                visualDensity: VisualDensity.standard,
              ),
              segments: <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 0,
                  label: Text(l10n.todaySegment),
                  icon: const Icon(Icons.today_outlined, size: 18),
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text(l10n.weekSegment),
                  icon: const Icon(Icons.date_range_outlined, size: 18),
                ),
              ],
              selected: <int>{_periodIndex},
              onSelectionChanged: (Set<int> next) {
                setState(() => _periodIndex = next.first);
              },
            ),
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _periodIndex == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _TodayContentCard(l10n: l10n),
            secondChild: _WeekChartCard(
              mockMinutes: _mockWeekMinutes,
              l10n: l10n,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.calendarLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          _DashboardCalendarSection(
            selectedDay: _selectedCalendarDay,
            onDayChanged: (DateTime d) {
              setState(() => _selectedCalendarDay = _dateOnly(d));
            },
            l10n: l10n,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.calendarHint,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _TodayContentCard extends StatelessWidget {
  const _TodayContentCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.todaysSummary,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _TodayRow(
              icon: Icons.timer_outlined,
              label: l10n.focusTimeLabel,
              value: l10n.focusMinutesValue(42),
              hint: l10n.statPlaceholder,
            ),
            const Divider(height: 24),
            _TodayRow(
              icon: Icons.flag_outlined,
              label: l10n.sessionsCompletedLabel,
              value: '2',
              hint: l10n.statPlaceholder,
            ),
            const Divider(height: 24),
            _TodayRow(
              icon: Icons.mood_outlined,
              label: l10n.moodCheckInsLabel,
              value: '1',
              hint: l10n.statPlaceholder,
            ),
            const Divider(height: 24),
            _TodayRow(
              icon: Icons.add_chart_outlined,
              label: l10n.xpGainedTodayLabel,
              value: '+30',
              hint: l10n.statPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: const Color(0xFF46AA57), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                hint,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF46AA57),
          ),
        ),
      ],
    );
  }
}

class _WeekChartCard extends StatelessWidget {
  const _WeekChartCard({required this.mockMinutes, required this.l10n});

  final List<double> mockMinutes;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final List<String> dayLabels =
        l10n.weekChartDayLabels.split(',').map((String s) => s.trim()).toList();
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.weekFocusMinutesTitle,
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
                  maxY: 60,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
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
                        reservedSize: 28,
                        interval: 20,
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
                    mockMinutes.length,
                    (int i) => BarChartGroupData(
                      x: i,
                      barRods: <BarChartRodData>[
                        BarChartRodData(
                          toY: mockMinutes[i],
                          width: 14,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          color: const Color(0xFF46AA57),
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
    );
  }
}

/// Material [CalendarDatePicker] plus a per-day summary (demo stats until backend exists).
class _DashboardCalendarSection extends StatelessWidget {
  const _DashboardCalendarSection({
    required this.selectedDay,
    required this.onDayChanged,
    required this.l10n,
  });

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayChanged;
  final AppLocalizations l10n;

  static const Color _green = Color(0xFF46AA57);

  static int _demoFocusMinutes(DateTime d) {
    final int x = d.year * 372 + d.month * 31 + d.day;
    return 10 + (x % 50);
  }

  static int _demoSessions(DateTime d) {
    final int x = d.year * 400 + d.month * 32 + d.day;
    return 1 + (x % 5);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations loc = MaterialLocalizations.of(context);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final bool isSelectedToday = selectedDay.year == today.year &&
        selectedDay.month == today.month &&
        selectedDay.day == today.day;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: _green,
                  ),
            ),
            child: CalendarDatePicker(
              initialDate: selectedDay,
              firstDate: DateTime(2020, 1, 1),
              lastDate: DateTime(now.year + 2, 12, 31),
              currentDate: today,
              onDateChanged: onDayChanged,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.event_note_rounded, size: 20, color: _green.withValues(alpha: 0.9)),
                    const SizedBox(width: 8),
                    Text(
                      l10n.daySummaryTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  loc.formatFullDate(selectedDay),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
                if (isSelectedToday) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    l10n.todayLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _DayStatTile(
                        icon: Icons.timer_outlined,
                        label: l10n.dayStatFocus,
                        value: l10n.focusMinutesValue(_demoFocusMinutes(selectedDay)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DayStatTile(
                        icon: Icons.flag_outlined,
                        label: l10n.dayStatSessions,
                        value: '${_demoSessions(selectedDay)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayStatTile extends StatelessWidget {
  const _DayStatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF46AA57).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 18, color: const Color(0xFF46AA57)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF46AA57),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF46AA57).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF46AA57),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
