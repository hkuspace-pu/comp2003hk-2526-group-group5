import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import 'app_colors.dart';
import 'main_shell_insets.dart';

class MoodLoggingPage extends StatefulWidget {
  const MoodLoggingPage({super.key, this.embedded = false});

  /// When true, omit [Scaffold] chrome for use inside [MainShellScreen].
  final bool embedded;

  @override
  State<MoodLoggingPage> createState() => _MoodLoggingPageState();
}

class _MoodLoggingPageState extends State<MoodLoggingPage> {
  static const Color _brandGreen = Color(0xFF46AA57);

  int selectedMood = 2;

  final List<IconData> moodIcons = <IconData>[
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];

  final List<Color> moodColors = <Color>[
    const Color(0xFFE57373),
    const Color(0xFFFFB74D),
    const Color(0xFFFFD54F),
    const Color(0xFF81C784),
    _brandGreen,
  ];

  int _selectedIndex = 0;

  List<String> _moodPhrases(AppLocalizations l10n) => <String>[
        l10n.moodVerySad,
        l10n.moodBitDown,
        l10n.moodNormal,
        l10n.moodGood,
        l10n.moodGreat,
      ];

  List<String> _moodScaleLabels(AppLocalizations l10n) => <String>[
        l10n.moodScaleVeryLow,
        l10n.moodScaleLow,
        l10n.moodScaleNormal,
        l10n.moodScaleGood,
        l10n.moodScaleGreat,
      ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _selectMood(int index) {
    HapticFeedback.lightImpact();
    setState(() => selectedMood = index);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<String> moodPhrases = _moodPhrases(l10n);
    final List<String> moodScaleLabels = _moodScaleLabels(l10n);

    final List<Widget> moodColumn = <Widget>[
      Text(
        l10n.moodQuestion,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        l10n.moodInstruction,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 24),
      Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Column(
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Column(
                  key: ValueKey<int>(selectedMood),
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: moodColors[selectedMood].withValues(alpha: 0.18),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: moodColors[selectedMood].withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        moodIcons[selectedMood],
                        color: moodColors[selectedMood],
                        size: 72,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      moodPhrases[selectedMood],
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moodScaleLabels[selectedMood],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _brandGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Gradient track (replaces bright blue bar)
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    moodColors.first.withValues(alpha: 0.45),
                                    moodColors[2].withValues(alpha: 0.5),
                                    moodColors.last.withValues(alpha: 0.55),
                                  ],
                                ),
                              ),
                              child: const SizedBox.expand(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List<Widget>.generate(moodIcons.length, (int i) {
                                return Container(
                                  width: 2,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List<Widget>.generate(moodIcons.length, (int i) {
                          return Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 22,
                            color: i == selectedMood ? _brandGreen : Colors.transparent,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List<Widget>.generate(moodIcons.length, (int i) {
                          final bool isSelected = i == selectedMood;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _selectMood(i),
                                  borderRadius: BorderRadius.circular(14),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOutCubic,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? _brandGreen.withValues(alpha: 0.65)
                                            : Colors.grey.shade200,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      color: isSelected
                                          ? _brandGreen.withValues(alpha: 0.08)
                                          : Colors.grey.shade50,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          moodIcons[i],
                                          color: moodColors[i],
                                          size: 28,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          moodScaleLabels[i],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? _brandGreen : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      if (!widget.embedded) const Spacer(),
      if (widget.embedded) const SizedBox(height: 8),
      FilledButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              content: Row(
                children: <Widget>[
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.moodSaved(moodPhrases[selectedMood]),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: FilledButton.styleFrom(
          backgroundColor: _brandGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        icon: const Icon(Icons.save_rounded, size: 22),
        label: Text(
          l10n.moodSaveButton,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      const SizedBox(height: 12),
    ];

    if (widget.embedded) {
      return ColoredBox(
        color: kMainShellBackground,
        child: ListView(
          padding: kMainTabScrollPadding,
          children: moodColumn,
        ),
      );
    }

    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        backgroundColor: _brandGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          l10n.moodLoggingTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: moodColumn,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: _brandGreen,
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.event_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.area_chart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }
}
