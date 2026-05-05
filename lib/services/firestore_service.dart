import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/user_profile.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  // User Account Operations

  Future<void> saveUserInitialData({
    required String uid,
    required String name,
    required String email,
    String? invitationCode,
  }) async {
    String role = 'user';
    String? groupId;

    if (invitationCode != null) {
      if (invitationCode.startsWith('COUNSELOR-')) {
        role = 'counselor';
      } else if (invitationCode.startsWith('FAMILY-')) {
        groupId = invitationCode;
      }
    }

    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'groupId': groupId,
      'totalXp': 0,
      'currentLevel': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'unlockedItems': [0],
      'cityLayout': [],
    });
  }

  Stream<DocumentSnapshot> getUserStream() {
    if (uid == null) return const Stream.empty();
    return _db.collection('users').doc(uid!).snapshots();
  }

  Future<UserProfile> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    return UserProfile.fromFirestore(doc);
  }

  // Activity Check for Idle Reminders
  /// Checks if the user has logged any sessions today.
  Future<bool> hasActivityToday() async {
    if (uid == null) return false;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid!)
          .collection('sessions')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint("Error checking today's activity: $e");
      return false;
    }
  }

  // Gamification & City Sync

  Future<void> syncGamificationData({
    required int xp,
    required int level,
    required List<int> unlockedItems,
    required List<Map<String, dynamic>> layout,
  }) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).update({
      'totalXp': xp,
      'currentLevel': level,
      'unlockedItems': unlockedItems,
      'cityLayout': layout,
    });
  }

  // Session & Activity Logging

  Future<void> logFocusSession({
    required int durationMinutes,
    required int xpEarned,
    String tag = "Focus Session",
    String? mediaUrl,
  }) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).collection('sessions').add({
      'duration': durationMinutes,
      'xpEarned': xpEarned,
      'tag': tag,
      'mediaUrl': mediaUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logMood({
    required int moodIndex,
    required String reflection,
  }) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).collection('moodLogs').add({
      'moodIndex': moodIndex,
      'reflection': reflection,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> resetUserHistory() async {
    if (uid == null) return;
    final userDoc = _db.collection('users').doc(uid!);
    final collections = ['sessions', 'activities', 'moodLogs'];

    for (String col in collections) {
      final snapshots = await userDoc.collection(col).get();
      final batch = _db.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  // TSV Data Export

  Future<void> exportUserDataAsTSV({String? targetUid}) async {
    final String? finalUid = targetUid ?? uid;
    if (finalUid == null) return;

    // Fetch both collections
    final sessionSnap = await _db.collection('users').doc(finalUid).collection('sessions').get();
    final moodSnap = await _db.collection('users').doc(finalUid).collection('moodLogs').get();

    List<Map<String, dynamic>> combined = [];

    for (var doc in sessionSnap.docs) {
      final d = doc.data();
      combined.add({
        'time': (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        'cat': 'Focus',
        'val': '${d['duration'] ?? 0} min',
        'xp': d['xpEarned'] ?? 0,
        'note': d['tag'] ?? 'N/A',
      });
    }

    for (var doc in moodSnap.docs) {
      final d = doc.data();
      combined.add({
        'time': (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        'cat': 'Mood',
        'val': 'Level ${d['moodIndex'] ?? 0}',
        'xp': 0,
        'note': d['reflection'] ?? 'N/A',
      });
    }

    // Sort: Newest First
    combined.sort((a, b) => b['time'].compareTo(a['time']));

    // Build TSV
    String tsv = "Timestamp\tCategory\tValue/Duration\tXP Earned\tNote/Reflection\n";
    for (var row in combined) {
      tsv += "${(row['time'] as DateTime).toIso8601String()}\t${row['cat']}\t${row['val']}\t${row['xp']}\t${row['note']}\n";
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/full_report_${finalUid.substring(0, 5)}.tsv');
    await file.writeAsString(tsv);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Focus City: Full Data Export (Sessions & Moods)',
      ),
    );
  }

  // Social & Leaderboard

  Stream<List<UserProfile>> getGroupLeaderboard(String groupId) {
    return _db.collection('users')
        .where('groupId', isEqualTo: groupId)
        .orderBy('totalXp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserProfile.fromFirestore(doc))
        .toList());
  }
}
