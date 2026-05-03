import 'package:cloud_firestore/cloud_firestore.dart';

// Auth/Settings logic.

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role;
  final int totalXp;
  final int currentLevel;
  final String? groupId;
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.totalXp,
    required this.currentLevel,
    this.groupId,
    this.createdAt,
  });

  // Helper to check permission (used in Counselor Dashboard)
  bool get isCounselor => role == 'counselor';

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? 'User',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      totalXp: data['totalXp'] ?? 0,
      currentLevel: data['currentLevel'] ?? 0,
      groupId: data['groupId'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Used for saving/updating user data in Firestore
  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role,
    'totalXp': totalXp,
    'currentLevel': currentLevel,
    'groupId': groupId,
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
  };
}