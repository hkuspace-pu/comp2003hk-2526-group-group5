import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../models/session_record.dart';
import 'gamification_provider.dart';

class FocusSessionProvider with ChangeNotifier {
  final GamificationProvider gamificationData;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Configuration ---
  static const Map<int, Duration> levelDurations = {
    0: Duration(minutes: 2), 1: Duration(minutes: 60), 2: Duration(minutes: 60),
    3: Duration(minutes: 90), 4: Duration(minutes: 120), 5: Duration(minutes: 150),
    6: Duration(minutes: 180),
  };

  static const Map<int, int> levelXpAwards = {
    0: 25, 1: 50, 2: 75, 3: 100, 4: 125, 5: 150, 6: 200
  };

  // Timer State
  Timer? timer;
  bool isRunning = false;
  Duration remainingDuration = Duration.zero;
  bool didCompleteNaturally = false;
  int xpAwardOnCompletion = 0;

  // Health/Break Reminder State
  int _continuousSeconds = 0;
  bool _hasPromptedBreak = false;
  static const int breakThresholdSeconds = 180 * 60; // 180 Minutes

  FocusSessionProvider(this.gamificationData) {
    _syncWithLevel();
  }

  void _syncWithLevel() {
    int level = gamificationData.currentCurrentLevel;
    remainingDuration = levelDurations[level] ?? levelDurations[0]!;
    xpAwardOnCompletion = levelXpAwards[level] ?? levelXpAwards[0]!;
  }

  void updateGamification(GamificationProvider newData) {
    if (!isRunning) {
      _syncWithLevel();
      notifyListeners();
    }
  }

  // --- 1. Dashboard Stream (Merged Focus & Offline) ---
  Stream<List<FocusSessionRecord>> get sessionStream {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    final focusStream = _firestore
        .collection('users').doc(userId).collection('sessions')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => FocusSessionRecord.fromFirestore(doc)).toList());

    final offlineStream = _firestore
        .collection('users').doc(userId).collection('activities')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      return FocusSessionRecord(
        type: 'Offline',
        durationMinutes: 0,
        xpEarned: data['xpBonus'] ?? 50,
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList());

    return Rx.combineLatest2<List<FocusSessionRecord>, List<FocusSessionRecord>, List<FocusSessionRecord>>(
      focusStream,
      offlineStream,
          (focus, offline) {
        final combined = [...focus, ...offline];
        combined.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return combined;
      },
    );
  }

  // --- 2. Timer Control Logic (Pause/Resume/Break Reminders) ---
  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(remainingDuration.inMinutes)}:${twoDigits(remainingDuration.inSeconds.remainder(60))}";
  }

  void startStopSession() {
    if (isRunning) {
      // PAUSE: Stop the timer but don't reset duration
      timer?.cancel();
      isRunning = false;
      notifyListeners();
    } else {
      // START / RESUME
      isRunning = true;
      didCompleteNaturally = false;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingDuration.inSeconds > 0) {
          remainingDuration -= const Duration(seconds: 1);

          // BREAK REMINDER CHECK [NEW]
          _continuousSeconds++;
          _checkBreakReminder();

          notifyListeners();
        } else {
          didCompleteNaturally = true;
          _finishSession();
        }
      });
      notifyListeners();
    }
  }

  void _checkBreakReminder() {
    if (_continuousSeconds >= breakThresholdSeconds && !_hasPromptedBreak) {
      _hasPromptedBreak = true;
      NotificationService().showBreakReminder();
    }
  }

  Future<void> _finishSession() async {
    timer?.cancel();
    isRunning = false;
    _resetBreakTracker();

    if (didCompleteNaturally) {
      final initialDuration = levelDurations[gamificationData.currentCurrentLevel] ?? levelDurations[0]!;
      await _firestoreService.logFocusSession(
        durationMinutes: initialDuration.inMinutes,
        xpEarned: xpAwardOnCompletion,
      );
      gamificationData.addXp(xpAwardOnCompletion);
    }

    _syncWithLevel();
    notifyListeners();
  }

  void stopSession() {
    timer?.cancel();
    isRunning = false;
    _resetBreakTracker();
    _syncWithLevel();
    notifyListeners();
  }

  void failSession() {
    if (isRunning) {
      timer?.cancel();
      isRunning = false;
      _resetBreakTracker();
      gamificationData.addXp(-50);
      _syncWithLevel();
      notifyListeners();
    }
  }

  void _resetBreakTracker() {
    _continuousSeconds = 0;
    _hasPromptedBreak = false;
  }

  void acknowledgeCompletion() {
    didCompleteNaturally = false;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}