import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:groupproject_group5/gamification_l10n.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import 'focus_city_layout.dart';

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
  bool _demoUnlockAll = false;
  List<ItemType> _unlockedItemTypes = [];
  List<PlacedItem> _placedItems = [];

  int get currentTotalXp => _totalXp;
  int get currentCurrentLevel => _currentLevel;
  List<ItemType> get currentUnlockedItemTypes => List.unmodifiable(_unlockedItemTypes);
  List<PlacedItem> get currentPlacedItems => List.unmodifiable(_placedItems);
  List<ItemInfo> get currentAllItems => List.unmodifiable(allItems);
  bool get currentDemoUnlockAll => _demoUnlockAll;

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

  /// Demo-only toggle: treat all palette items as unlocked for drag-and-drop.
  void toggleDemoUnlockAll() {
    _demoUnlockAll = !_demoUnlockAll;
    notifyListeners();
  }
}

class FocusSessionData extends ChangeNotifier {
  static const Map<int, Duration> levelDurations = {
    0: Duration(minutes: 25), 1: Duration(minutes: 40), 2: Duration(minutes: 60),
    3: Duration(minutes: 90), 4: Duration(minutes: 120), 5: Duration(minutes: 150), 6: Duration(minutes: 180),
  };
  static const Map<int, int> levelXpAwards = {0: 2000, 1: 15, 2: 25, 3: 35, 4: 45, 5: 50, 6: 50};

  Timer? timer;
  bool isRunning = false;
  Duration remainingDuration = Duration.zero;
  bool didCompleteNaturally = false;
  Duration initialDurationForLevel = Duration.zero;
  /// User-editable session length (defaults from level; see [setSessionMinutes]).
  Duration _sessionTarget = Duration.zero;
  int xpAwardOnCompletion = 0;

  final GamificationData gamificationData;
  late VoidCallback gamificationListener;

  FocusSessionData(this.gamificationData) {
    _updateSessionSettings(gamificationData.currentCurrentLevel);
    remainingDuration = _sessionTarget;

    gamificationListener = () {
      final int newLevel = gamificationData.currentCurrentLevel;
      _updateSessionSettings(newLevel);
      resetSession();
    };
    gamificationData.addListener(gamificationListener);
  }

  void _updateSessionSettings(int level) {
    initialDurationForLevel = levelDurations[level] ?? levelDurations[0]!;
    _sessionTarget = initialDurationForLevel;
    xpAwardOnCompletion = levelXpAwards[level] ?? levelXpAwards[0]!;
  }

  /// Current target length for Start / full reset (minutes).
  int get targetMinutes => _sessionTarget.inMinutes;

  bool get currentIsRunning => isRunning;
  Duration get currentRemainingDuration => remainingDuration;
  /// Paused mid-session (time left but not the full target length).
  bool get canResumeSession =>
      !isRunning &&
      remainingDuration > Duration.zero &&
      remainingDuration < _sessionTarget;
  bool get currentDidCompleteNaturally => didCompleteNaturally;
  Duration get currentInitialDuration => initialDurationForLevel;
  int get currentXpAwardOnCompletion => xpAwardOnCompletion;

  /// `M:SS` with **no** leading zero on minutes (e.g. `1:05`, `12:00`, not `01:05`).
  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final int minutes = remainingDuration.inMinutes;
    final int seconds = remainingDuration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }

  /// Time already spent this session (target − remaining); for elapsed display.
  String get formattedElapsed {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final Duration elapsed = _sessionTarget - remainingDuration;
    final Duration safe = elapsed.isNegative ? Duration.zero : elapsed;
    final int minutes = safe.inMinutes;
    final int seconds = safe.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }

  void startStopSession() {
    if (isRunning) {
      stopSession();
    } else {
      if (remainingDuration > Duration.zero) {
        startSession();
      } else {
        didCompleteNaturally = false;
        remainingDuration = _sessionTarget;
        startSession();
      }
    }
    notifyListeners();
  }

  /// Set session length in minutes (only while not running).
  void setSessionMinutes(int minutes) {
    if (isRunning) {
      return;
    }
    final int m = minutes.clamp(1, 180);
    _sessionTarget = Duration(minutes: m);
    remainingDuration = _sessionTarget;
    didCompleteNaturally = false;
    notifyListeners();
  }

  /// Start from full target time (ignores partial remaining).
  void startFromFull() {
    stopSession();
    didCompleteNaturally = false;
    remainingDuration = _sessionTarget;
    startSession();
    notifyListeners();
  }

  void pauseSession() {
    stopSession();
    notifyListeners();
  }

  /// Continue after [pauseSession] if time is left.
  void resumeSession() {
    if (!isRunning && remainingDuration > Duration.zero) {
      startSession();
      notifyListeners();
    }
  }

  /// End session now (no completion XP). Resets remaining time to the target for the next start.
  void finishSessionEarly() {
    stopSession();
    didCompleteNaturally = false;
    remainingDuration = _sessionTarget;
    notifyListeners();
  }

  void startSession() {
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingDuration.inSeconds > 0) {
        remainingDuration -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        didCompleteNaturally = true;
        stopSession();
        notifyListeners();
      }
    });
  }

  void stopSession() {
    timer?.cancel();
    isRunning = false;
  }

  void resetSession() {
    stopSession();
    remainingDuration = initialDurationForLevel;
    didCompleteNaturally = false;
    notifyListeners();
  }

  void acknowledgeCompletion() {
    didCompleteNaturally = false;
  }

  @override
  void dispose() {
    gamificationData.removeListener(gamificationListener);
    timer?.cancel();
    super.dispose();
  }
}

/// Green drag-and-drop city + optional overlay timer (used below [FocusSessionPanel]).
class _FocusCityGreenCanvas extends StatelessWidget {
  const _FocusCityGreenCanvas({this.compact = false});

  /// ~細三分之一: smaller on-map items + timer vs [FocusCityPage] full size.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FocusSessionData, GamificationData>(
      builder: (BuildContext context, FocusSessionData focusData,
          GamificationData gamificationData, _) {
        if (focusData.currentDidCompleteNaturally) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            HapticFeedback.vibrate();
            final AppLocalizations l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                l10n.focusCompletedXp(focusData.currentXpAwardOnCompletion),
              ),
            ));
            gamificationData.addXp(focusData.currentXpAwardOnCompletion);
            focusData.acknowledgeCompletion();
          });
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double itemSize = compact ? 32.0 : 48.0;
            final double timerFont = compact ? 32.0 : 48.0;
            // Show remaining time on the green area while running *or* paused (frozen).
            final bool showTimerOnGreen =
                focusData.currentIsRunning || focusData.canResumeSession;

            return Stack(
              children: <Widget>[
                DragTarget<ItemType>(
                  onWillAcceptWithDetails: (DragTargetDetails<ItemType>? details) {
                    return !focusData.currentIsRunning;
                  },
                  onAcceptWithDetails: (DragTargetDetails<ItemType> details) {
                    if (focusData.currentIsRunning) {
                      return;
                    }
                    final RenderBox renderBox =
                        context.findRenderObject()! as RenderBox;
                    final Offset localOffset =
                        renderBox.globalToLocal(details.offset);
                    final double normalizedX =
                        (localOffset.dx / constraints.maxWidth)
                            .clamp(0.0, 1.0);
                    final double normalizedY =
                        (localOffset.dy / constraints.maxHeight)
                            .clamp(0.0, 1.0);
                    gamificationData.placeItem(
                        details.data, Offset(normalizedX, normalizedY));
                  },
                  builder: (BuildContext context, _, __) => DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFF5EAD5E),
                          Color(0xFF4A9F4A),
                          Color(0xFF3D8F3D),
                        ],
                      ),
                    ),
                    child: showTimerOnGreen
                        ? Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                focusData.formattedTime,
                                style: TextStyle(
                                  fontSize: timerFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.expand(),
                  ),
                ),
                ...gamificationData.currentPlacedItems
                    .asMap()
                    .entries
                    .map((MapEntry<int, PlacedItem> entry) {
                  final int index = entry.key;
                  final PlacedItem placedItem = entry.value;
                  final ItemInfo itemInfo =
                      gamificationData.getItemInfo(placedItem.type);

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
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              Container(
                            width: itemSize * 1.2,
                            height: itemSize * 1.2,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          itemInfo.imagePath,
                          width: itemSize,
                          height: itemSize,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              Container(
                            width: itemSize,
                            height: itemSize,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Image.asset(
                        itemInfo.imagePath,
                        width: itemSize,
                        height: itemSize,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) =>
                            Container(
                          width: itemSize,
                          height: itemSize,
                          color: Colors.grey,
                        ),
                      ),
                      onDragEnd: (DraggableDetails details) {
                        final Offset o = details.offset;
                        final RenderBox? renderBox =
                            context.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          final Offset localOffset =
                              renderBox.globalToLocal(o);
                          final double newX =
                              (localOffset.dx / constraints.maxWidth)
                                  .clamp(0.0, 1.0);
                          final double newY =
                              (localOffset.dy / constraints.maxHeight)
                                  .clamp(0.0, 1.0);
                          gamificationData.updateItemPosition(
                              index, newX, newY);
                        }
                      },
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}

/// City builder + focus session (shared by [FocusCityPage] and main-shell Focus tab).
class FocusCityBody extends StatelessWidget {
  const FocusCityBody({
    super.key,
    this.progressTitle = "TODAY'S CITY PROGRESS",
    this.progressSubtitle = 'Build your city with each focus session',
    this.showLevelLine = true,
    this.showBottomStartStopButton = true,
    this.sessionToolbar,
    /// Main shell Focus tab: scale down progress / session / strip / place palette (~細三分之一).
    this.compact = false,
  });

  final String progressTitle;
  final String progressSubtitle;
  final bool showLevelLine;
  final bool showBottomStartStopButton;
  /// Placed under the Level / XP line (e.g. [FocusSessionPanel] from the main shell).
  final Widget? sessionToolbar;
  final bool compact;

  static const Color _brandGreen = Color(0xFF46AA57);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final MediaQueryData mq = MediaQuery.of(context);
    final double fallbackViewportH = mq.size.height;
    final double keyboardInset = mq.viewInsets.bottom;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewportH = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : fallbackViewportH;
        // Middle (toolbar + green): total height cap; flex below balances card vs green (less green-heavy).
        final double middleH = compact
            ? (viewportH * 0.62).clamp(420.0, 820.0)
            : (viewportH * 0.42).clamp(240.0, 560.0);
        final double inset = FocusCityLayout.gutter(compact);
        final double cardR = FocusCityLayout.radius(compact);
        final double innerPadH = FocusCityLayout.cardPaddingH(compact);
        final double innerPadV = FocusCityLayout.cardPaddingV(compact);
        final double iconPad = FocusCityLayout.iconPadding(compact);
        final double iconRadius = FocusCityLayout.iconBoxRadius(compact);
        final double iconSz = compact ? 18.0 : 22.0;
        final double titleGap = compact ? 12.0 : 14.0;
        final double subtitleSz = compact ? 11.0 : 13.0;
        final double lineGap = compact ? 5.0 : 6.0;
        final double divPad = compact ? 9.0 : 14.0;
        final double starSz = compact ? 14.0 : 18.0;
        final double starGap = compact ? 6.0 : 8.0;
        final double lvlFs = compact ? 12.0 : 14.0;
        final double greenR = FocusCityLayout.radius(compact);
        final double placeTile = compact
            ? FocusCityLayout.placeTileCompact
            : FocusCityLayout.placeTileFull;
        final double placeColW =
            placeTile + FocusCityLayout.placeColExtra(compact);

        final double shellW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mq.size.width;
        final double contentMaxW = FocusCityLayout.contentMaxWidth(shellW);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: FocusCityLayout.scrollBottomPadding(compact, keyboardInset),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxW),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(inset, compact ? 2 : 6, inset, 0),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardR),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(innerPadH, innerPadV, innerPadH, innerPadV),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(iconPad),
                        decoration: BoxDecoration(
                          color: _brandGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(iconRadius),
                        ),
                        child: Icon(
                          Icons.location_city_rounded,
                          size: iconSz,
                          color: _brandGreen,
                        ),
                      ),
                      SizedBox(width: titleGap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              progressTitle,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                                height: 1.25,
                                fontSize: compact ? 13 : null,
                              ),
                            ),
                            SizedBox(height: lineGap),
                            Text(
                              progressSubtitle,
                              style: TextStyle(
                                fontSize: subtitleSz,
                                height: 1.35,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showLevelLine) ...<Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: divPad),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    Consumer<GamificationData>(
                      builder: (BuildContext context,
                          GamificationData gamificationData, _) {
                        return Row(
                          children: <Widget>[
                            Icon(
                              Icons.stars_rounded,
                              size: starSz,
                              color: _brandGreen.withValues(alpha: 0.85),
                            ),
                            SizedBox(width: starGap),
                            Text(
                              l10n.levelXpLine(
                                gamificationData.currentCurrentLevel,
                                gamificationData.currentTotalXp,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: lvlFs,
                                color: _brandGreen,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        sessionToolbar != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(inset, compact ? 6 : 6, inset, 0),
                child: SizedBox(
                  height: middleH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Keep session controls at natural height, and let green canvas
                      // consume the remaining area to avoid a large blank gap.
                      sessionToolbar!,
                      SizedBox(height: compact ? 10 : 12),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: compact ? 6 : 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(greenR),
                            child: _FocusCityGreenCanvas(compact: compact),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(inset, compact ? 8 : 12, inset, compact ? 8 : 8),
                child: SizedBox(
                  height: middleH,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(greenR),
                    child: _FocusCityGreenCanvas(compact: compact),
                  ),
                ),
              ),

        Consumer<GamificationData>(
          builder: (BuildContext context, GamificationData gamificationData, _) =>
              Padding(
            padding: EdgeInsets.fromLTRB(inset, compact ? 10 : 8, inset, compact ? 8 : 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FocusCityLayout.radius(compact)),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: compact ? 4 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 8 : 12,
                  vertical: compact ? 8 : 10,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.flag_outlined,
                      size: compact ? 14 : 18,
                      color: _brandGreen.withValues(alpha: 0.9),
                    ),
                    SizedBox(width: compact ? 6 : 10),
                    Expanded(
                      child: Text(
                        localizedNextUnlockProgress(
                          gamificationData,
                          l10n,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: compact ? 10.5 : 11.5,
                          height: 1.35,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(inset, 0, inset, compact ? 1 : 2),
          child: Consumer<FocusSessionData>(
            builder: (BuildContext context, FocusSessionData focusData, _) {
              final bool running = focusData.currentIsRunning;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    l10n.placeItemsTitle,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.2,
                      fontSize: compact ? 10.5 : 12,
                    ),
                  ),
                  if (running) ...<Widget>[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.orange.shade200,
                          ),
                        ),
                        child: Text(
                          l10n.pauseDragHint,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange.shade900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: Consumer2<FocusSessionData, GamificationData>(
            builder: (BuildContext context, FocusSessionData focusData,
                GamificationData gamificationData, _) {
              final bool allowDrag = !focusData.currentIsRunning;
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(FocusCityLayout.radius(compact)),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: compact ? 8 : 4,
                    horizontal: compact ? 8 : 4,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ...gamificationData.currentAllItems.map((ItemInfo itemInfo) {
                          final bool isUnlocked = gamificationData.currentDemoUnlockAll ||
                              gamificationData.currentUnlockedItemTypes
                                  .contains(itemInfo.type);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 3 : 2,
                            ),
                            child: SizedBox(
                              width: placeColW,
                              child: DraggableUnlockableItem(
                                itemInfo: itemInfo,
                                isUnlocked: isUnlocked,
                                allowDrag: allowDrag,
                                tileSize: placeTile,
                              ),
                            ),
                          );
                        }),
                        SizedBox(width: compact ? 6 : 10),
                        SizedBox(
                          height: compact ? 30 : 34,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              gamificationData.toggleDemoUnlockAll();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: compact ? 8 : 10,
                              ),
                              side: BorderSide(
                                color: gamificationData.currentDemoUnlockAll
                                    ? _brandGreen.withValues(alpha: 0.65)
                                    : Colors.grey.shade300,
                              ),
                              backgroundColor: gamificationData.currentDemoUnlockAll
                                  ? _brandGreen.withValues(alpha: 0.08)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(
                              Icons.bolt_rounded,
                              size: compact ? 15 : 16,
                              color: gamificationData.currentDemoUnlockAll
                                  ? _brandGreen
                                  : Colors.grey.shade700,
                            ),
                            label: Text(
                              gamificationData.currentDemoUnlockAll
                                  ? l10n.demoOn
                                  : l10n.demo,
                              style: TextStyle(
                                fontSize: compact ? 11 : 12,
                                fontWeight: FontWeight.w700,
                                color: gamificationData.currentDemoUnlockAll
                                    ? _brandGreen
                                    : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (showBottomStartStopButton) ...<Widget>[
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: SizedBox(
              height: 44,
              width: double.infinity,
              child: Consumer<FocusSessionData>(
                builder:
                    (BuildContext context, FocusSessionData focusData, _) =>
                        FilledButton.icon(
                  onPressed: focusData.startStopSession,
                  icon: Icon(focusData.currentIsRunning
                      ? Icons.stop
                      : Icons.play_arrow),
                  label: Text(
                    focusData.currentIsRunning
                        ? l10n.endFocusSession
                        : l10n.startFocusSessionMinutes(focusData.targetMinutes),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF46AA57),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FocusCityLayout.radius(compact),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: EdgeInsets.fromLTRB(inset, compact ? 10 : 8, inset, compact ? 14 : 16),
          child: Consumer<GamificationData>(
            builder: (BuildContext context, GamificationData gamificationData, _) =>
                OutlinedButton.icon(
              onPressed: () => gamificationData.reset(),
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.grey.shade800,
                size: compact ? 18 : 24,
              ),
              label: Text(
                l10n.resetCityProgress,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  fontSize: compact ? 12 : null,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                side: BorderSide(color: Colors.grey.shade300),
                padding: EdgeInsets.symmetric(vertical: compact ? 10 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FocusCityLayout.radius(compact)),
                ),
              ),
            ),
          ),
        ),
      ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FocusCityPage extends StatelessWidget {
  const FocusCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        title: Text(l10n.focusCityAppBar),
        centerTitle: true,
      ),
      body: FocusCityBody(
        progressTitle: l10n.focusCityProgressTitle,
        progressSubtitle: l10n.focusCityProgressSubtitle,
        showBottomStartStopButton: true,
      ),
    );
  }
}

class DraggableUnlockableItem extends StatelessWidget {
  final ItemInfo itemInfo;
  final bool isUnlocked;
  /// When false (e.g. focus timer running), palette items cannot be dragged to the city.
  final bool allowDrag;
  /// Thumbnail edge length (default 48; use ~32 for compact “Place items” strip).
  final double tileSize;

  const DraggableUnlockableItem({
    required this.itemInfo,
    required this.isUnlocked,
    this.allowDrag = true,
    this.tileSize = 48,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String itemLabel = localizedItemLabel(itemInfo.type, l10n);
    final double size = tileSize;
    final double r = (size * 0.22).clamp(4.0, 10.0);
    final double gap = (size * 0.1).clamp(2.0, 4.0);
    final double labelFs = (size * 0.28).clamp(9.0, 13.0);
    final double subFs = (size * 0.24).clamp(8.0, 12.0);
    final double feedback = size + (size * 0.35).clamp(12.0, 18.0);

    if (!isUnlocked) {
      return Opacity(
        opacity: 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(r),
              child: Image.asset(
                itemInfo.imagePath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Container(
                  width: size,
                  height: size,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade600,
                    size: size * 0.45,
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            Text(
              itemLabel,
              style: TextStyle(fontSize: labelFs, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              l10n.xpAmount(itemInfo.unlockXp),
              style: TextStyle(
                fontSize: subFs,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final Widget paletteChild = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(r),
          child: Image.asset(
            itemInfo.imagePath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                Container(
              width: size,
              height: size,
              color: const Color(0xFF46AA57).withValues(alpha: 0.35),
              child: Icon(Icons.image_outlined, color: Colors.white, size: size * 0.45),
            ),
          ),
        ),
        SizedBox(height: gap),
        Text(
          itemLabel,
          style: TextStyle(fontSize: labelFs, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.placeLabel,
          style: TextStyle(fontSize: subFs, fontWeight: FontWeight.bold),
        ),
      ],
    );

    if (!allowDrag) {
      return Tooltip(
        message: l10n.pausePlaceTooltip,
        child: Opacity(
          opacity: 0.55,
          child: paletteChild,
        ),
      );
    }

    return Draggable<ItemType>(
      data: itemInfo.type,
      feedback: Material(
        color: Colors.transparent,
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            itemInfo.imagePath,
            width: feedback,
            height: feedback,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                Container(
              width: feedback,
              height: feedback,
              color: const Color(0xFF46AA57),
              child: Icon(Icons.image_outlined, color: Colors.white, size: feedback * 0.45),
            ),
          ),
        ),
      ),
      child: paletteChild,
    );
  }
}