import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_info.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';

class GamificationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Timer to prevent "Over-Saving" (Debouncing)
  Timer? _saveTimer;

  // Static Configuration
  static const List<ItemInfo> allItems = [
    ItemInfo(type: ItemType.tree, label: 'Tree', imagePath: 'images/tree.png', unlockXp: 0, levelUnlock: 0, description: 'Adds natural beauty to your city'),
    ItemInfo(type: ItemType.park, label: 'Park', imagePath: 'images/park.png', unlockXp: 250, levelUnlock: 1, description: 'A green space for relaxation and play'),
    ItemInfo(type: ItemType.house, label: 'House', imagePath: 'images/house.png', unlockXp: 500, levelUnlock: 2, description: 'Provides shelter for citizens'),
    ItemInfo(type: ItemType.building, label: 'Building', imagePath: 'images/building.png', unlockXp: 750, levelUnlock: 3, description: 'A tall structure to mark your progress'),
    ItemInfo(type: ItemType.road, label: 'Road', imagePath: 'images/road.png', unlockXp: 1000, levelUnlock: 4, description: 'Connects your city\'s areas'),
    ItemInfo(type: ItemType.river, label: 'River', imagePath: 'images/river.png', unlockXp: 1250, levelUnlock: 5, description: 'A flowing waterway for scenic beauty'),
    ItemInfo(type: ItemType.bridge, label: 'Bridge', imagePath: 'images/bridge.png', unlockXp: 1500, levelUnlock: 6, description: 'Spans over rivers and gaps'),
  ];

  static const Map<int, int> levelXpThresholds = {0: 0, 1: 250, 2: 500, 3: 750, 4: 1000, 5: 1250, 6: 1500};

  // State Variables
  DateTime? _gamificationStartDate;
  int _totalXp = 0;
  int _currentLevel = 0;
  final List<ItemType> _unlockedItemTypes = [ItemType.tree];
  final List<PlacedItem> _cityLayout = [];

  GamificationProvider() {
    // Start initialization after the first frame to keep app startup smooth
    Future.microtask(() => _initializeData());
  }

  // Initialization Logic
  Future<void> _initializeData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load Start Date
      int? startTime = prefs.getInt('gamificationStartTime');
      if (startTime == null) {
        startTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('gamificationStartTime', startTime);
      }
      _gamificationStartDate = DateTime.fromMillisecondsSinceEpoch(startTime);

      // Load XP and Level
      _totalXp = prefs.getInt('totalXp') ?? 0;
      _calculateLevel();

      // Load Layout with safety checks
      final List<String>? savedLayout = prefs.getStringList('cityLayout');
      if (savedLayout != null) {
        _cityLayout.clear();
        for (var e in savedLayout) {
          try {
            _cityLayout.add(PlacedItem.fromJson(jsonDecode(e)));
          } catch (e) {
            debugPrint("Data corruption check: Skipping one invalid item.");
          }
        }
      }

      // Check for idle status on app startup
      _checkIdleStatus();

      notifyListeners();
    } catch (e) {
      debugPrint("Gamification initialization error: $e");
    }
  }

  // Idle Reminder Logic
  /// Encourages a focus session if no activity is detected in the afternoon.
  Future<void> _checkIdleStatus() async {
    final now = DateTime.now();
    // Only remind the user in the afternoon (after 2 PM) if they haven't earned XP today
    if (now.hour >= 14) {
      final bool activeToday = await _firestoreService.hasActivityToday();
      if (!activeToday) {
        NotificationService().showNotification(
          id: 102,
          title: "Your city is waiting!",
          body: "No growth detected today. Ready for a focus session?",
        );
      }
    }
  }

  // Getters
  int get currentTotalXp => _totalXp;
  int get currentCurrentLevel => _currentLevel;
  DateTime get gamificationStartDate => _gamificationStartDate ?? DateTime.now();
  List<ItemType> get currentUnlockedItemTypes => List.unmodifiable(_unlockedItemTypes);
  List<PlacedItem> get currentPlacedItems => List.unmodifiable(_cityLayout);
  List<ItemInfo> get currentAllItems => List.unmodifiable(allItems);

  String get timeSpentString {
    final Duration duration = DateTime.now().difference(gamificationStartDate);
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    if (days == 0 && hours == 0) return 'Just started today';
    return '$days d $hours h active';
  }

  String get nextUnlockProgress {
    int currentLv = _currentLevel;
    if (currentLv >= 6) return "All items unlocked! City Complete!";

    int nextThreshold = levelXpThresholds[currentLv + 1] ?? 0;
    int remaining = nextThreshold - _totalXp;

    if (remaining <= 0) return "New items available! Level up to see more.";
    return "Next unlock at $nextThreshold XP (Need $remaining more XP)";
  }

  // Core Business Logic
  void addXp(int xp) {
    _totalXp = (_totalXp + xp).clamp(0, 999999);
    _checkProgress();
    _requestSave(); // Queue a save task
    notifyListeners();
  }

  void placeItem(ItemType type, Offset position) {
    _cityLayout.add(PlacedItem(type: type, x: position.dx, y: position.dy));
    _requestSave();
    notifyListeners();
  }

  void updateItemPosition(int index, double x, double y) {
    if (index >= 0 && index < _cityLayout.length) {
      _cityLayout[index] = PlacedItem(type: _cityLayout[index].type, x: x, y: y);
      _requestSave();
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _totalXp = 0;
    _currentLevel = 0;
    _unlockedItemTypes.clear();
    _unlockedItemTypes.add(ItemType.tree);
    _cityLayout.clear();

    await _firestoreService.resetUserHistory();
    await _saveAllToStorage();

    notifyListeners();
  }

  void _calculateLevel() {
    int newLevel = 0;
    levelXpThresholds.forEach((level, threshold) {
      if (_totalXp >= threshold) newLevel = level;
    });
    _currentLevel = newLevel.clamp(0, 6);
  }

  void _checkProgress() {
    _calculateLevel();
    for (var item in allItems) {
      if (_totalXp >= item.unlockXp && !_unlockedItemTypes.contains(item.type)) {
        _unlockedItemTypes.add(item.type);
      }
    }
  }

  // Intelligent Sync Logic

  /// Requests a save but waits 2 seconds for more changes.
  /// If the user moves 10 items, we only save ONCE at the end.
  void _requestSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), () => _saveAllToStorage());
  }

  Future<void> _saveAllToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save Local
      await prefs.setInt('totalXp', _totalXp);
      await prefs.setInt('currentLevel', _currentLevel);
      await prefs.setStringList('cityLayout', _cityLayout.map((e) => jsonEncode(e.toJson())).toList());

      // Save Cloud (Firestore)
      await _firestoreService.syncGamificationData(
        xp: _totalXp,
        level: _currentLevel,
        unlockedItems: _unlockedItemTypes.map((e) => e.index).toList(),
        layout: _cityLayout.map((e) => e.toJson()).toList(),
      );

      debugPrint("Gamification data synced successfully.");
    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }

  ItemInfo getItemInfo(ItemType type) => allItems.firstWhere((item) => item.type == type);

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }
}