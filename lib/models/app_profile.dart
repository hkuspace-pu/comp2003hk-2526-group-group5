class AppProfile {
  const AppProfile({required this.id, required this.name});

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory AppProfile.fromJson(Map<String, dynamic> j) {
    return AppProfile(
      id: j['id'] as String,
      name: j['name'] as String,
    );
  }
}
