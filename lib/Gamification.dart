import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

void main() {
  runApp(const FocusCityApp());
}

class FocusCityApp extends StatelessWidget {
  const FocusCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GamificationData()),
          ChangeNotifierProvider<FocusSessionData>(
            create: (context) {
              final gamificationData = Provider.of<GamificationData>(context, listen: false);
              return FocusSessionData(gamificationData);
            },
          ),
        ],
        child: const FocusCityPage(),
      ),
    );
  }
}

class FocusCityPage extends StatelessWidget {
  const FocusCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF46AA57),
        elevation: 0,
        centerTitle: true,
        title: const Text('Focus City', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Consumer<GamificationData>(
              builder: (context, gamificationData, _) => Text(
                "TODAY'S CITY (Lv: ${gamificationData.currentCurrentLevel}, XP: ${gamificationData.currentTotalXp})",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Build your city with focus sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Consumer2<FocusSessionData, GamificationData>(
              builder: (context, focusData, gamificationData, _) {
                if (focusData.currentDidCompleteNaturally) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    HapticFeedback.vibrate();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Completed! +${focusData.currentXpAwardOnCompletion} XP!'),
                    ));
                    gamificationData.addXp(focusData.currentXpAwardOnCompletion);
                    focusData.acknowledgeCompletion();
                  });
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    const double itemSize = 48.0;
                    final bool hideTimer = !focusData.currentIsRunning;

                    return Stack(
                      children: [
                        DragTarget<ItemType>(
                          onAcceptWithDetails: (details) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final Offset localOffset = renderBox.globalToLocal(details.offset);
                            final double normalizedX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                            final double normalizedY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                            gamificationData.placeItem(details.data, Offset(normalizedX, normalizedY));
                          },
                          builder: (context, _, __) => Container(
                            color: const Color(0xFF63B63B),
                            child: hideTimer ? null : Center(
                              child: Text(
                                focusData.formattedTime,
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
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
                                if (details.offset != null) {
                                  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                                  if (renderBox != null) {
                                    final localOffset = renderBox.globalToLocal(details.offset!);
                                    final newX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                    final newY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                    gamificationData.updateItemPosition(index, newX, newY);
                                  }
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

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Consumer<FocusSessionData>(
                builder: (context, focusData, _) => ElevatedButton.icon(
                  onPressed: focusData.startStopSession,
                  icon: Icon(focusData.currentIsRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(focusData.currentIsRunning
                      ? 'END FOCUS SESSION'
                      : 'START ${focusData.currentInitialDuration.inMinutes}-MIN FOCUS SESSION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46AA57),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          Container(
            height: 64,
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomIcon(icon: Icons.home),
                _BottomIcon(icon: Icons.event),
                _BottomIcon(icon: Icons.area_chart),
                _BottomIcon(icon: Icons.settings),
              ],
            ),
          ),
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

    return Draggable<ItemType>(
      data: itemInfo.type,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          itemInfo.imagePath,
          width: size + 16,
          height: size + 16,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size + 16,
            height: size + 16,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 24),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ FIX 3: Add this too
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
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(itemInfo.label,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
          const Text('Place',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
class _BottomIcon extends StatelessWidget {
  final IconData icon;
  const _BottomIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(icon, color: Colors.black87));
  }
}