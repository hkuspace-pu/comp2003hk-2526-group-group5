import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Remote persistence for user profile, gamification sync, sessions, and related collections.
class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveUserInitialData({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': 'user',
      'counselorId': null,
      'totalXp': 0,
      'currentLevel': 0,
      'unlockedItems': [],
      'cityLayout': [],
      'createdAt': FieldValue.serverTimestamp(),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> getUserStream() {
    if (uid == null) throw Exception('User not logged in');
    return _db.collection('users').doc(uid!).snapshots();
  }

  Future<void> syncGamificationData({
    required int xp,
    required int level,
    required List<int> unlockedItems,
    required List<Map<String, dynamic>> layout,
  }) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).set({
      'totalXp': xp,
      'currentLevel': level,
      'unlockedItems': unlockedItems,
      'cityLayout': layout,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> logFocusSession({
    required int durationMinutes,
    required int xpEarned,
    required String tag,
  }) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid!).collection('sessions').add({
      'startTime': FieldValue.serverTimestamp(),
      'duration': durationMinutes,
      'xpEarned': xpEarned,
      'tag': tag,
    });

    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpEarned),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logOfflineActivity({
    required String activityType,
    required String comment,
    required List<String> mediaUrls,
    required int xpBonus,
  }) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid!).collection('activities').add({
      'timestamp': FieldValue.serverTimestamp(),
      'type': activityType,
      'comment': comment,
      'mediaUrls': mediaUrls,
      'xpBonus': xpBonus,
    });

    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpBonus),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveMoodLog(int moodIndex, String reflection) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).collection('moodLogs').add({
      'timestamp': FieldValue.serverTimestamp(),
      'moodIndex': moodIndex,
      'reflection': reflection,
    });
  }

  Future<void> syncHealthData({
    required int steps,
    required double calories,
    required int xpBonus,
  }) async {
    if (uid == null) return;

    await _db.collection('users').doc(uid!).collection('healthLogs').add({
      'timestamp': FieldValue.serverTimestamp(),
      'steps': steps,
      'calories': calories,
      'xpBonus': xpBonus,
    });

    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpBonus),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getCounselees(String counselorId) {
    return _db
        .collection('users')
        .where('counselorId', isEqualTo: counselorId)
        .snapshots();
  }
}
