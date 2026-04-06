class FocusSessionRecord {
  FocusSessionRecord({
    required this.id,
    required this.profileId,
    required this.start,
    required this.end,
    required this.durationSeconds,
    required this.xpEarned,
    required this.autoCompleted,
    required this.timerKind,
  });

  final String id;
  final String profileId;
  final DateTime start;
  final DateTime end;
  final int durationSeconds;
  final int xpEarned;
  /// True when countdown reached zero without early stop.
  final bool autoCompleted;
  /// 'countdown' | 'stopwatch'
  final String timerKind;

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'durationSeconds': durationSeconds,
        'xpEarned': xpEarned,
        'autoCompleted': autoCompleted,
        'timerKind': timerKind,
      };

  factory FocusSessionRecord.fromJson(Map<String, dynamic> j) {
    return FocusSessionRecord(
      id: j['id'] as String,
      profileId: j['profileId'] as String? ?? 'default',
      start: DateTime.parse(j['start'] as String),
      end: DateTime.parse(j['end'] as String),
      durationSeconds: j['durationSeconds'] as int,
      xpEarned: j['xpEarned'] as int,
      autoCompleted: j['autoCompleted'] as bool? ?? false,
      timerKind: j['timerKind'] as String? ?? 'countdown',
    );
  }
}
