import 'staff_end_user.dart';

/// Sample directory data for Staff UI (replace with Firestore query later).
List<StaffEndUser> staffSampleEndUsers() {
  return const <StaffEndUser>[
    StaffEndUser(
      id: 'u_1001',
      displayName: 'Alex Chan',
      email: 'alex.chan@student.edu.hk',
      level: 8,
      totalXp: 1240,
      lastActiveLabel: 'Today · 09:12',
      focusMinutesThisWeek: 185,
      statusLabel: 'Active',
    ),
    StaffEndUser(
      id: 'u_1002',
      displayName: 'Sam Wong',
      email: 'sam.wong@student.edu.hk',
      level: 5,
      totalXp: 620,
      lastActiveLabel: 'Yesterday',
      focusMinutesThisWeek: 92,
      statusLabel: 'Active',
    ),
    StaffEndUser(
      id: 'u_1003',
      displayName: 'Jamie Lee',
      email: 'jamie.lee@student.edu.hk',
      level: 12,
      totalXp: 2100,
      lastActiveLabel: '3 days ago',
      focusMinutesThisWeek: 240,
      statusLabel: 'Active',
    ),
    StaffEndUser(
      id: 'u_1004',
      displayName: 'Taylor Ho',
      email: 'taylor.ho@student.edu.hk',
      level: 3,
      totalXp: 310,
      lastActiveLabel: '1 week ago',
      focusMinutesThisWeek: 45,
      statusLabel: 'Quiet',
    ),
    StaffEndUser(
      id: 'u_1005',
      displayName: 'Riley Au',
      email: 'riley.au@student.edu.hk',
      level: 7,
      totalXp: 980,
      lastActiveLabel: 'Today · 14:40',
      focusMinutesThisWeek: 156,
      statusLabel: 'Active',
    ),
    StaffEndUser(
      id: 'u_1006',
      displayName: 'Casey Lam',
      email: 'casey.lam@student.edu.hk',
      level: 2,
      totalXp: 180,
      lastActiveLabel: '2 weeks ago',
      focusMinutesThisWeek: 20,
      statusLabel: 'Quiet',
    ),
  ];
}
