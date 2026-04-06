class ActivityEntry {
  ActivityEntry({
    required this.id,
    required this.profileId,
    required this.loggedAt,
    required this.type,
    required this.description,
    this.mediaUrl,
  });

  final String id;
  final String profileId;
  final DateTime loggedAt;
  final String type;
  final String description;
  final String? mediaUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'loggedAt': loggedAt.toIso8601String(),
        'type': type,
        'description': description,
        'mediaUrl': mediaUrl,
      };

  factory ActivityEntry.fromJson(Map<String, dynamic> j) {
    return ActivityEntry(
      id: j['id'] as String,
      profileId: j['profileId'] as String? ?? 'default',
      loggedAt: DateTime.parse(j['loggedAt'] as String),
      type: j['type'] as String,
      description: j['description'] as String? ?? '',
      mediaUrl: j['mediaUrl'] as String?,
    );
  }
}
