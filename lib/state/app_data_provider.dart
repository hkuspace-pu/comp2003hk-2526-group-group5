import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/activity_entry.dart';
import '../models/app_profile.dart';
import '../models/focus_session_record.dart';
import '../models/mood_entry.dart';

/// In-memory store for demo sessions/moods/activities (no Hive / Supabase yet).
class AppDataProvider extends ChangeNotifier {
  AppDataProvider() : _uuid = const Uuid();

  final Uuid _uuid;

  List<AppProfile> _profiles = [const AppProfile(id: 'default', name: 'Default')];
  String _currentProfileId = 'default';
  List<FocusSessionRecord> _sessions = [];
  List<MoodEntry> _moods = [];
  List<ActivityEntry> _activities = [];

  bool _ready = true;
  bool get isReady => _ready;

  List<AppProfile> get profiles => List.unmodifiable(_profiles);
  String get currentProfileId => _currentProfileId;
  AppProfile? get currentProfile {
    try {
      return _profiles.firstWhere((p) => p.id == _currentProfileId);
    } catch (_) {
      return _profiles.isNotEmpty ? _profiles.first : null;
    }
  }

  List<FocusSessionRecord> get sessions => List.unmodifiable(_sessions);
  List<MoodEntry> get moods => List.unmodifiable(_moods);
  List<ActivityEntry> get activities => List.unmodifiable(_activities);

  Future<void> init() async {
    _ready = true;
    notifyListeners();
  }

  Future<void> switchProfile(String profileId) async {
    if (!_profiles.any((p) => p.id == profileId)) return;
    _currentProfileId = profileId;
    notifyListeners();
  }

  Future<void> addProfile(String name) async {
    final id = _uuid.v4();
    _profiles = [..._profiles, AppProfile(id: id, name: name)];
    notifyListeners();
  }

  Future<void> addFocusSession(FocusSessionRecord record) async {
    _sessions = [record, ..._sessions];
    notifyListeners();
  }

  Future<void> addMood(MoodEntry entry) async {
    _moods = [entry, ..._moods];
    notifyListeners();
  }

  Future<void> addActivity(ActivityEntry entry) async {
    _activities = [entry, ..._activities];
    notifyListeners();
  }

  bool hasLogsOn(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    bool sameDay(DateTime t) {
      final x = DateTime(t.year, t.month, t.day);
      return x == d;
    }

    return _sessions.any((s) => sameDay(s.start)) ||
        _moods.any((m) => sameDay(m.loggedAt)) ||
        _activities.any((a) => sameDay(a.loggedAt));
  }
}
