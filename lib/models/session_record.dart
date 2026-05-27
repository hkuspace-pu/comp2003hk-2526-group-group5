import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSessionRecord {
  final String type;
  final int durationMinutes;
  final int xpEarned;
  final DateTime timestamp;

  FocusSessionRecord({
    required this.type,
    required this.durationMinutes,
    required this.xpEarned,
    required this.timestamp,
  });

  factory FocusSessionRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FocusSessionRecord(
      type: data['type'] ?? 'Focus Session',
      durationMinutes: data['duration'] ?? 0,
      xpEarned: data['xpEarned'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}