import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Profile / account stats (separate from Focus City [GamificationData] in `city_gamification_state.dart`).
class GamificationData extends ChangeNotifier {
  DateTime? _gamificationStartDate;
  int _totalXp = 0;
  int _currentLevel = 0;

  int get currentXp => _totalXp;
  int get currentLevel => _currentLevel;
  DateTime get gamificationStartDate =>
      _gamificationStartDate ?? DateTime.now();

  GamificationData() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadFromStorage();
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _gamificationStartDate = DateTime.fromMillisecondsSinceEpoch(
      prefs.getInt('gamificationStartTime') ??
          DateTime.now().millisecondsSinceEpoch,
    );
    _totalXp = prefs.getInt('totalXp') ?? 1500;
    _currentLevel = prefs.getInt('currentLevel') ?? 4;
  }

  Future<void> _saveToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'gamificationStartTime', gamificationStartDate.millisecondsSinceEpoch);
    await prefs.setInt('totalXp', _totalXp);
    await prefs.setInt('currentLevel', _currentLevel);
  }

  Future<void> addFocusTime(Duration sessionDuration,
      {int xpPerMinute = 5}) async {
    final int xpGained = (sessionDuration.inMinutes * xpPerMinute).toInt();
    await addXp(xpGained);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> addXp(int xp) async {
    _totalXp += xp;
    _updateLevel();
  }

  void _updateLevel() {
    _currentLevel = (_totalXp / 250).floor().clamp(0, 10);
  }

  int get totalItemsCollected => 0;

  String get timeSpentString {
    final Duration duration = DateTime.now().difference(gamificationStartDate);
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    final int minutes = duration.inMinutes.remainder(60);

    final List<String> parts = <String>[];
    if (days > 0) parts.add('$days day${days == 1 ? '' : 's'}');
    if (hours > 0) parts.add('$hours hour${hours == 1 ? '' : 's'}');
    if (minutes > 0) parts.add('$minutes minute${minutes == 1 ? '' : 's'}');

    return parts.isEmpty ? 'Just started!' : parts.join(', ');
  }
}
