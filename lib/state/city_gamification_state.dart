import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/city_item.dart';

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

class FocusSessionData extends ChangeNotifier {
  static const Map<int, Duration> levelDurations = {
    0: Duration(minutes: 1), 1: Duration(minutes: 40), 2: Duration(minutes: 60),
    3: Duration(minutes: 90), 4: Duration(minutes: 120), 5: Duration(minutes: 150), 6: Duration(minutes: 180),
  };
  static const Map<int, int> levelXpAwards = {0: 2000, 1: 15, 2: 25, 3: 35, 4: 45, 5: 50, 6: 50};

  Timer? timer;
  bool isRunning = false;
  Duration remainingDuration = Duration.zero;
  bool didCompleteNaturally = false;
  Duration initialDurationForLevel = Duration.zero;
  int xpAwardOnCompletion = 0;

  final GamificationData gamificationData;
  late VoidCallback gamificationListener;

  FocusSessionData(this.gamificationData) {
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
  Duration get currentRemainingDuration => remainingDuration;
  bool get currentDidCompleteNaturally => didCompleteNaturally;
  Duration get currentInitialDuration => initialDurationForLevel;
  int get currentXpAwardOnCompletion => xpAwardOnCompletion;

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final int minutes = remainingDuration.inMinutes;
    final int seconds = remainingDuration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  void startStopSession() {
    if (isRunning) {
      stopSession();
    } else {
      if (remainingDuration > Duration.zero) {
        startSession();
      } else {
        didCompleteNaturally = false;
        remainingDuration = initialDurationForLevel;
        startSession();
      }
    }
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
