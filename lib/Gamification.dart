import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'l10n/locale_controller.dart';
import 'models/focus_session_record.dart';
import 'state/app_data_provider.dart';

enum ItemType { tree, park, house, building, road, river, bridge }

class ItemInfo {
  final ItemType type;
  final String label;
  final String imagePath;
  final int unlockXp;
  final int levelUnlock;
  final String description;

  const ItemInfo({
    required this.type,
    required this.label,
    required this.imagePath,
    required this.unlockXp,
    required this.levelUnlock,
    required this.description,
  });
}

class PlacedItem {
  ItemType type;
  double x;
  double y;

  PlacedItem({required this.type, required this.x, required this.y});

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'x': x,
    'y': y,
  };

  factory PlacedItem.fromJson(Map<String, dynamic> json) => PlacedItem(
    type: ItemType.values[json['type']],
    x: json['x'].toDouble(),
    y: json['y'].toDouble(),
  );
}

class GamificationData extends ChangeNotifier {
  static const List<ItemInfo> allItems = [
    ItemInfo(type: ItemType.tree, label: 'Tree', imagePath: 'images/tree.png', unlockXp: 10, levelUnlock: 0, description: 'Adds natural beauty to your city'),
    ItemInfo(type: ItemType.park, label: 'Park', imagePath: 'images/park.png', unlockXp: 50, levelUnlock: 1, description: 'A green space for relaxation and play'),
    ItemInfo(type: ItemType.house, label: 'House', imagePath: 'images/house.png', unlockXp: 200, levelUnlock: 2, description: 'Provides shelter for citizens'),
    ItemInfo(type: ItemType.building, label: 'Building', imagePath: 'images/building.png', unlockXp: 400, levelUnlock: 3, description: 'A tall structure to mark your progress'),
    ItemInfo(type: ItemType.road, label: 'Road', imagePath: 'images/road.png', unlockXp: 800, levelUnlock: 4, description: 'Connects your city\'s areas'),
    ItemInfo(type: ItemType.river, label: 'River', imagePath: 'images/river.png', unlockXp: 1200, levelUnlock: 5, description: 'A flowing waterway for scenic beauty'),
    ItemInfo(type: ItemType.bridge, label: 'Bridge', imagePath: 'images/bridge.png', unlockXp: 2000, levelUnlock: 6, description: 'Spans over rivers and gaps'),
  ];
  static const Map<int, int> levelXpThresholds = {
    0: 0,
    1: 50,
    2: 200,
    3: 400,
    4: 800,
    5: 1200,
    6: 2000,
  };

  int _totalXp = 0;
  int _currentLevel = 0;
  List<ItemType> _unlockedItemTypes = [];
  List<PlacedItem> _placedItems = [];

  int get currentTotalXp => _totalXp;
  int get currentCurrentLevel => _currentLevel;
  List<ItemType> get currentUnlockedItemTypes => List.unmodifiable(_unlockedItemTypes);
  List<PlacedItem> get currentPlacedItems => List.unmodifiable(_placedItems);
  List<ItemInfo> get currentAllItems => List.unmodifiable(allItems);

  GamificationData() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _totalXp = prefs.getInt('totalXp') ?? 0;
    _currentLevel = prefs.getInt('currentLevel') ?? 0;

    final unlockedJson = prefs.getStringList('unlockedItems') ?? [];
    _unlockedItemTypes = unlockedJson.map((typeIndex) => ItemType.values[int.parse(typeIndex)]).toList();

    final placedJson = prefs.getStringList('placedItems') ?? [];
    _placedItems = placedJson.map((jsonString) => PlacedItem.fromJson(jsonDecode(jsonString))).toList();

    _checkProgress();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalXp', _totalXp);
    await prefs.setInt('currentLevel', _currentLevel);

    final unlockedJson = _unlockedItemTypes.map((type) => type.index.toString()).toList();
    await prefs.setStringList('unlockedItems', unlockedJson);

    final placedJson = _placedItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('placedItems', placedJson);
  }

  ItemInfo getItemInfo(ItemType type) {
    return allItems.firstWhere((item) => item.type == type);
  }

  Future<void> addXp(int xp) async {
    _totalXp += xp;
    await _checkProgress();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _checkProgress() async {
    int newLevel = _currentLevel;
    levelXpThresholds.forEach((level, threshold) {
      if (_totalXp >= threshold && level > newLevel) newLevel = level;
    });
    if (newLevel != _currentLevel) _currentLevel = newLevel;

    for (final ItemInfo item in allItems) {
      if (_totalXp >= item.unlockXp && !_unlockedItemTypes.contains(item.type)) {
        _unlockedItemTypes.add(item.type);
      }
    }
  }

  String get nextUnlockProgress {
    ItemInfo? nextItemToUnlock;
    final List<ItemInfo> sortedItems = List<ItemInfo>.from(allItems)
      ..sort((ItemInfo a, ItemInfo b) => a.unlockXp.compareTo(b.unlockXp));

    for (final ItemInfo item in sortedItems) {
      if (!_unlockedItemTypes.contains(item.type)) {
        nextItemToUnlock = item;
        break;
      }
    }

    final int nextLevel = _currentLevel + 1;
    final int? nextLevelXpThreshold = levelXpThresholds[nextLevel];

    if (nextItemToUnlock != null && nextLevelXpThreshold != null) {
      if (nextItemToUnlock.unlockXp <= nextLevelXpThreshold) {
        return 'NEXT UNLOCK AT ${nextItemToUnlock.unlockXp} XP: ${nextItemToUnlock.label} • ${nextItemToUnlock.description}';
      } else {
        return 'NEXT UNLOCK AT $nextLevelXpThreshold XP: Level $nextLevel';
      }
    } else if (nextItemToUnlock != null) {
      return 'NEXT UNLOCK AT ${nextItemToUnlock.unlockXp} XP: ${nextItemToUnlock.label} • ${nextItemToUnlock.description}';
    } else if (nextLevelXpThreshold != null) {
      return 'NEXT UNLOCK AT $nextLevelXpThreshold XP: Level $nextLevel';
    }
    return 'All items unlocked and maximum level achieved!';
  }

  Future<void> placeItem(ItemType type, Offset position) async {
    _placedItems.add(PlacedItem(type: type, x: position.dx.clamp(0.0, 1.0), y: position.dy.clamp(0.0, 1.0)));
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> updateItemPosition(int index, double newX, double newY) async {
    if (index >= 0 && index < _placedItems.length) {
      _placedItems[index] = PlacedItem(
        type: _placedItems[index].type,
        x: newX.clamp(0.0, 1.0),
        y: newY.clamp(0.0, 1.0),
      );
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _totalXp = 0;
    _currentLevel = 0;
    _unlockedItemTypes.clear();
    _placedItems.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('totalXp');
    await prefs.remove('currentLevel');
    await prefs.remove('unlockedItems');
    await prefs.remove('placedItems');

    notifyListeners();
  }
}

/// Countdown (auto-complete at 0) vs stopwatch (manual stop to save).
enum FocusTimerKind { countdown, stopwatch }

class FocusSessionData extends ChangeNotifier {
  static const Map<int, Duration> levelDurations = {
    0: Duration(minutes: 1), 1: Duration(minutes: 40), 2: Duration(minutes: 60),
    3: Duration(minutes: 90), 4: Duration(minutes: 120), 5: Duration(minutes: 150), 6: Duration(minutes: 180),
  };
  static const Map<int, int> levelXpAwards = {0: 2000, 1: 15, 2: 25, 3: 35, 4: 45, 5: 50, 6: 50};

  final GamificationData gamificationData;
  final AppDataProvider appData;
  final Uuid _uuid = const Uuid();
  late VoidCallback gamificationListener;

  Timer? timer;
  bool isRunning = false;
  /// Timer stopped without saving; user can [resumeFocus] to continue.
  bool isPaused = false;
  Duration remainingDuration = Duration.zero;
  Duration elapsedStopwatch = Duration.zero;
  bool didCompleteNaturally = false;
  int lastXpAwarded = 0;
  Duration initialDurationForLevel = Duration.zero;
  int xpAwardOnCompletion = 0;
  FocusTimerKind timerKind = FocusTimerKind.countdown;
  DateTime? _startedAt;

  FocusSessionData(this.gamificationData, this.appData) {
    _updateSessionSettings(gamificationData.currentCurrentLevel);
    remainingDuration = initialDurationForLevel;

    gamificationListener = () {
      final int newLevel = gamificationData.currentCurrentLevel;
      _updateSessionSettings(newLevel);
      resetSession();
    };
    gamificationData.addListener(gamificationListener);
  }

  void _updateSessionSettings(int level) {
    initialDurationForLevel = levelDurations[level] ?? levelDurations[0]!;
    xpAwardOnCompletion = levelXpAwards[level] ?? levelXpAwards[0]!;
  }

  bool get currentIsRunning => isRunning;
  bool get currentIsPaused => isPaused;
  bool get hasActiveSession => isRunning || isPaused;
  Duration get currentRemainingDuration => remainingDuration;
  bool get currentDidCompleteNaturally => didCompleteNaturally;
  Duration get currentInitialDuration => initialDurationForLevel;
  int get currentXpAwardOnCompletion => xpAwardOnCompletion;
  FocusTimerKind get currentTimerKind => timerKind;

  void setTimerKind(FocusTimerKind k) {
    if (isRunning || isPaused) return;
    timerKind = k;
    elapsedStopwatch = Duration.zero;
    remainingDuration = initialDurationForLevel;
    notifyListeners();
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (timerKind == FocusTimerKind.stopwatch) {
      final int minutes = elapsedStopwatch.inMinutes;
      final int seconds = elapsedStopwatch.inSeconds.remainder(60);
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    final int minutes = remainingDuration.inMinutes;
    final int seconds = remainingDuration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  /// Separate game-style primary / secondary buttons.
  void startFocus() {
    if (isRunning || isPaused) return;
    _start();
  }

  /// Pause countdown/stopwatch without recording XP (can [resumeFocus]).
  void pauseFocus() {
    if (!isRunning) return;
    timer?.cancel();
    timer = null;
    isRunning = false;
    isPaused = true;
    notifyListeners();
  }

  void resumeFocus() {
    if (!isPaused || isRunning) return;
    isPaused = false;
    isRunning = true;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  /// End session and record XP (replaces old one-shot stop).
  void finishFocusSession() {
    timer?.cancel();
    timer = null;
    if (!isRunning && !isPaused) {
      notifyListeners();
      return;
    }
    isRunning = false;
    isPaused = false;
    if (_startedAt == null) {
      notifyListeners();
      return;
    }
    if (timerKind == FocusTimerKind.stopwatch &&
        elapsedStopwatch.inSeconds < 5) {
      _startedAt = null;
      elapsedStopwatch = Duration.zero;
      notifyListeners();
      return;
    }
    unawaited(_finalizeAndRecord(naturalComplete: false));
  }

  void _start() {
    isRunning = true;
    isPaused = false;
    _startedAt = DateTime.now();
    didCompleteNaturally = false;
    lastXpAwarded = 0;
    if (timerKind == FocusTimerKind.countdown) {
      if (remainingDuration <= Duration.zero) {
        remainingDuration = initialDurationForLevel;
      }
    } else {
      elapsedStopwatch = Duration.zero;
    }
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void _tick() {
    if (timerKind == FocusTimerKind.countdown) {
      if (remainingDuration.inSeconds > 0) {
        remainingDuration -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        timer?.cancel();
        timer = null;
        isRunning = false;
        unawaited(_finalizeAndRecord(naturalComplete: true));
      }
    } else {
      elapsedStopwatch += const Duration(seconds: 1);
      notifyListeners();
    }
  }

  Future<void> _finalizeAndRecord({required bool naturalComplete}) async {
    if (_startedAt == null) return;
    final DateTime start = _startedAt!;
    final DateTime end = DateTime.now();
    _startedAt = null;

    final int totalSec = initialDurationForLevel.inSeconds.clamp(1, 86400);
    int durationSec;
    String kindStr;
    if (timerKind == FocusTimerKind.stopwatch) {
      durationSec = elapsedStopwatch.inSeconds.clamp(1, 86400);
      kindStr = 'stopwatch';
      elapsedStopwatch = Duration.zero;
    } else {
      durationSec =
          (totalSec - remainingDuration.inSeconds).clamp(1, totalSec);
      if (naturalComplete) {
        durationSec = totalSec;
      }
      kindStr = 'countdown';
      remainingDuration = initialDurationForLevel;
    }

    int xp;
    if (timerKind == FocusTimerKind.stopwatch) {
      final double ratio = durationSec / (totalSec > 0 ? totalSec : 60);
      xp = (xpAwardOnCompletion * ratio).round().clamp(1, xpAwardOnCompletion);
    } else if (naturalComplete) {
      xp = xpAwardOnCompletion;
    } else {
      xp = (xpAwardOnCompletion * durationSec / totalSec).round().clamp(
            1,
            xpAwardOnCompletion,
          );
    }

    lastXpAwarded = xp;
    didCompleteNaturally = naturalComplete;

    final record = FocusSessionRecord(
      id: _uuid.v4(),
      profileId: appData.currentProfileId,
      start: start,
      end: end,
      durationSeconds: durationSec,
      xpEarned: xp,
      autoCompleted: naturalComplete,
      timerKind: kindStr,
    );
    await appData.addFocusSession(record);
    await gamificationData.addXp(xp);
    notifyListeners();
  }

  void resetSession() {
    timer?.cancel();
    timer = null;
    isRunning = false;
    isPaused = false;
    _startedAt = null;
    remainingDuration = initialDurationForLevel;
    elapsedStopwatch = Duration.zero;
    didCompleteNaturally = false;
    lastXpAwarded = 0;
    notifyListeners();
  }

  void acknowledgeCompletion() {
    didCompleteNaturally = false;
    lastXpAwarded = 0;
  }

  @override
  void dispose() {
    gamificationData.removeListener(gamificationListener);
    timer?.cancel();
    super.dispose();
  }
}

class FocusCityPage extends StatelessWidget {
  const FocusCityPage({super.key});

  void _showHistory(BuildContext context) {
    final tr = context.read<LocaleController>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Consumer<AppDataProvider>(
          builder: (context, data, _) {
            final list = data.sessions;
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(tr.focusNoSessionsYet),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = list[i];
                final m = s.durationSeconds ~/ 60;
                final trh = context.watch<LocaleController>();
                return ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(
                    '${trh.isEnglish ? '$m min' : '$m 分鐘'} · +${s.xpEarned} XP',
                  ),
                  subtitle: Text(
                    s.autoCompleted ? trh.focusAutoComplete : trh.focusManualEnd,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF46AA57),
        elevation: 0,
        centerTitle: true,
        title: Text(
          tr.focusCityTitle,
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: tr.focusSessionHistory,
            onPressed: () => _showHistory(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Consumer<GamificationData>(
              builder: (context, gamificationData, _) => Text(
                '${tr.focusTodaysCity} (Lv: ${gamificationData.currentCurrentLevel}, XP: ${gamificationData.currentTotalXp})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              tr.focusBuildCityTagline,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Consumer<FocusSessionData>(
              builder: (context, focusData, _) {
                return SegmentedButton<FocusTimerKind>(
                  segments: [
                    ButtonSegment(
                      value: FocusTimerKind.countdown,
                      label: Text(tr.focusTimerCountdown),
                      icon: const Icon(Icons.hourglass_top, size: 18),
                    ),
                    ButtonSegment(
                      value: FocusTimerKind.stopwatch,
                      label: Text(tr.focusTimerStopwatch),
                      icon: const Icon(Icons.timer, size: 18),
                    ),
                  ],
                  selected: {focusData.currentTimerKind},
                  onSelectionChanged: (s) {
                    if (!focusData.hasActiveSession) {
                      focusData.setTimerKind(s.first);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<FocusSessionData>(
              builder: (context, focusData, _) {
                final gameText = GoogleFonts.fredoka(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: const [
                    Shadow(color: Colors.black38, offset: Offset(0, 2), blurRadius: 0),
                  ],
                );
                return Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (focusData.currentIsRunning) {
                            focusData.pauseFocus();
                          } else if (focusData.currentIsPaused) {
                            focusData.resumeFocus();
                          } else {
                            focusData.startFocus();
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          disabledBackgroundColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Text(
                          focusData.currentIsRunning
                              ? tr.focusPause
                              : focusData.currentIsPaused
                                  ? tr.focusResume
                                  : tr.focusStart,
                          style: gameText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: focusData.hasActiveSession
                            ? () => focusData.finishFocusSession()
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Text(tr.focusFinish, style: gameText),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              tr.focusDragHint,
              style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: Consumer2<FocusSessionData, GamificationData>(
              builder: (context, focusData, gamificationData, _) {
                if (focusData.lastXpAwarded > 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    HapticFeedback.vibrate();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${context.read<LocaleController>().focusLoggedXp}${focusData.lastXpAwarded} XP',
                        ),
                      ),
                    );
                    focusData.acknowledgeCompletion();
                  });
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    const double itemSize = 48.0;
                    final bool hideTimer = !focusData.hasActiveSession;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: DragTarget<ItemType>(
                          onAcceptWithDetails: (details) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final Offset localOffset = renderBox.globalToLocal(details.offset);
                            final double normalizedX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                            final double normalizedY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                            gamificationData.placeItem(details.data, Offset(normalizedX, normalizedY));
                          },
                          builder: (context, candidateData, rejected) {
                            final hovering = candidateData.isNotEmpty;
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF63B63B),
                                border: Border.all(
                                  color: hovering ? const Color(0xFFFFEB3B) : const Color(0xFF558B2F),
                                  width: hovering ? 4 : 2,
                                ),
                                boxShadow: hovering
                                    ? [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.45),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (hideTimer)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.swipe_up, color: Colors.white.withOpacity(0.85), size: 42),
                                            const SizedBox(height: 8),
                                            Text(
                                              '遊戲區域\n按住下方圖示拖到呢度',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.92),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    Center(
                                      child: Text(
                                        focusData.formattedTime,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 52,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              blurRadius: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        ),

                        ...gamificationData.currentPlacedItems.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final PlacedItem placedItem = entry.value;
                          final itemInfo = gamificationData.getItemInfo(placedItem.type);

                          return Positioned(
                            left: placedItem.x * constraints.maxWidth - itemSize / 2,
                            top: placedItem.y * constraints.maxHeight - itemSize / 2,
                            child: Draggable<PlacedItem>(
                              data: placedItem,
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  itemInfo.imagePath,
                                  width: itemSize * 1.2,
                                  height: itemSize * 1.2,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(width: itemSize * 1.2, height: itemInfo.imagePath.contains('tree') ? itemSize * 1.2 : itemSize * 1.2, color: Colors.grey),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  itemInfo.imagePath,
                                  width: itemSize,
                                  height: itemSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(width: itemSize, height: itemSize, color: Colors.grey),
                                ),
                              ),
                              child: Image.asset(
                                itemInfo.imagePath,
                                width: itemSize,
                                height: itemSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(width: itemSize, height: itemSize, color: Colors.grey),
                              ),
                              onDragEnd: (details) {
                                final o = details.offset;
                                final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                                if (renderBox != null) {
                                  final localOffset = renderBox.globalToLocal(o);
                                  final newX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                  final newY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                  gamificationData.updateItemPosition(index, newX, newY);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Consumer<GamificationData>(
            builder: (context, gamificationData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text(gamificationData.nextUnlockProgress,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Consumer<GamificationData>(
              builder: (context, gamificationData, _) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: gamificationData.currentAllItems.map((itemInfo) {
                      final bool isUnlocked = gamificationData.currentUnlockedItemTypes.contains(itemInfo.type);
                      return SizedBox(
                        width: 70,
                        child: DraggableUnlockableItem(itemInfo: itemInfo, isUnlocked: isUnlocked),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Consumer<GamificationData>(
                builder: (context, gamificationData, _) => ElevatedButton.icon(
                  onPressed: () => gamificationData.reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESET GAMIFICATION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF46AA57),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class DraggableUnlockableItem extends StatelessWidget {
  final ItemInfo itemInfo;
  final bool isUnlocked;

  const DraggableUnlockableItem({
    required this.itemInfo,
    required this.isUnlocked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 48;

    if (!isUnlocked) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              itemInfo.imagePath,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 4),
            Text(itemInfo.label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${itemInfo.unlockXp} XP',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      );
    }

    return Tooltip(
      message: '按住拖到上方綠色區域',
      child: Draggable<ItemType>(
        data: itemInfo.type,
        feedback: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            itemInfo.imagePath,
            width: size + 24,
            height: size + 24,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size + 24,
              height: size + 24,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.white, size: 24),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: Image.asset(
            itemInfo.imagePath,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  itemInfo.imagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              itemInfo.label,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              '拖到公園',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800),
            ),
          ],
        ),
      ),
    );
  }
}