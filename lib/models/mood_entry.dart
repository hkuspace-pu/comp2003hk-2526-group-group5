class MoodEntry {
  MoodEntry({
    required this.id,
    required this.profileId,
    required this.loggedAt,
    required this.moodIndex,
    required this.reflection,
  });

  final String id;
  final String profileId;
  final DateTime loggedAt;
  /// 0–4 matching mood scale in UI.
  final int moodIndex;
  final String reflection;

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'loggedAt': loggedAt.toIso8601String(),
        'moodIndex': moodIndex,
        'reflection': reflection,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> j) {
    return MoodEntry(
      id: j['id'] as String,
      profileId: j['profileId'] as String? ?? 'default',
      loggedAt: DateTime.parse(j['loggedAt'] as String),
      moodIndex: j['moodIndex'] as int,
      reflection: j['reflection'] as String? ?? '',
    );
  }
}
