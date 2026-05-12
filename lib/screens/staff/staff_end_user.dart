/// A student / end-user row shown in the Staff user directory (UI model).
class StaffEndUser {
  const StaffEndUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.level,
    required this.totalXp,
    required this.lastActiveLabel,
    required this.focusMinutesThisWeek,
    required this.statusLabel,
  });

  final String id;
  final String displayName;
  final String email;
  final int level;
  final int totalXp;
  final String lastActiveLabel;
  final int focusMinutesThisWeek;
  final String statusLabel;
}
