import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// get the current logged-in user's UID
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  /// Create initial user document after Sign Up
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

  /// Get real-time stream of the current user's profile (for auto-updating UI)
  Stream<DocumentSnapshot> getUserStream() {
    if (uid == null) throw Exception("User not logged in");
    return _db.collection('users').doc(uid!).snapshots();
  }

  /// Syncs "Focus City" layout, XP, and Level to the cloud
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

  /// Logs a completed Focus Session
  Future<void> logFocusSession({
    required int durationMinutes,
    required int xpEarned,
    required String tag,
  }) async {
    if (uid == null) return;

    /// Add record to sub-collection
    await _db.collection('users').doc(uid!).collection('sessions').add({
      'startTime': FieldValue.serverTimestamp(),
      'duration': durationMinutes,
      'xpEarned': xpEarned,
      'tag': tag,
    });

    /// Atomically increment total XP in the main document
    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpEarned),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  /// Logs offline activities (Jogging, Painting) with multimedia links
  Future<void> logOfflineActivity({
    required String activityType,
    required String comment,
    required List<String> mediaUrls,   // Links from Firebase Storage
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

    /// Update total XP
    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpBonus),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  /// Saves daily mood index and reflection
  Future<void> saveMoodLog(int moodIndex, String reflection) async {
    if (uid == null) return;
    await _db.collection('users').doc(uid!).collection('moodLogs').add({
      'timestamp': FieldValue.serverTimestamp(),
      'moodIndex': moodIndex,
      'reflection': reflection,
    });
  }

  /// Connects Apple Health / Google Fit data to Firebase
  Future<void> syncHealthData({
    required int steps,
    required double calories,
    required int xpBonus,
  }) async {
    if (uid == null) return;

    // Record health sync history
    await _db.collection('users').doc(uid!).collection('healthLogs').add({
      'timestamp': FieldValue.serverTimestamp(),
      'steps': steps,
      'calories': calories,
      'xpBonus': xpBonus,
    });

    // Award XP and update last active time
    await _db.collection('users').doc(uid!).update({
      'totalXp': FieldValue.increment(xpBonus),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  /// Allows a Counselor to see all users assigned to them
  Stream<QuerySnapshot> getCounselees(String counselorId) {
    return _db
        .collection('users')
        .where('counselorId', isEqualTo: counselorId)
        .snapshots();
  }
}

