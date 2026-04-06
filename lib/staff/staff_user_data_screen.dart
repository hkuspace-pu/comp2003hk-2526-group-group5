import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity_entry.dart';
import '../models/focus_session_record.dart';
import '../models/mood_entry.dart';
import '../state/app_data_provider.dart';

/// Read-only view of user profiles and linked logs (demo: in-memory [AppDataProvider]).
class StaffUserDataScreen extends StatelessWidget {
  const StaffUserDataScreen({super.key});

  static const Color _accent = Color(0xFF2B579A);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, data, _) {
        final profiles = data.profiles;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'User data access',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse profiles and recent logs stored in the app (read-only demo).',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ...profiles.map(
              (p) {
                final sessions = data.sessions.where((s) => s.profileId == p.id).length;
                final moods = data.moods.where((m) => m.profileId == p.id).length;
                final acts = data.activities.where((a) => a.profileId == p.id).length;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: const CircleAvatar(
                      backgroundColor: _accent,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Profile ID: ${p.id}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                          children: [
                            _miniChip('Sessions', sessions),
                            const SizedBox(width: 8),
                            _miniChip('Moods', moods),
                            const SizedBox(width: 8),
                            _miniChip('Activities', acts),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      _RecentSessionsSection(
                        records: data.sessions.where((s) => s.profileId == p.id).take(5).toList(),
                      ),
                      _RecentMoodsSection(
                        entries: data.moods.where((m) => m.profileId == p.id).take(5).toList(),
                      ),
                      _RecentActivitiesSection(
                        entries: data.activities.where((a) => a.profileId == p.id).take(5).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (profiles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No profiles yet.'),
              ),
          ],
        );
      },
    );
  }

  static Widget _miniChip(String label, int count) {
    return Chip(
      label: Text('$label: $count'),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _RecentSessionsSection extends StatelessWidget {
  const _RecentSessionsSection({required this.records});

  final List<FocusSessionRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Recent focus sessions',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        ...records.map(
          (s) => ListTile(
            dense: true,
            leading: const Icon(Icons.timer_outlined, size: 20),
            title: Text('${s.durationSeconds ~/ 60} min · +${s.xpEarned} XP'),
            subtitle: Text(
              '${s.start.toLocal()}',
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentMoodsSection extends StatelessWidget {
  const _RecentMoodsSection({required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Recent moods',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        ...entries.map(
          (m) => ListTile(
            dense: true,
            leading: const Icon(Icons.mood, size: 20),
            title: Text('Index ${m.moodIndex + 1}/5'),
            subtitle: Text(
              m.reflection.isEmpty ? '—' : m.reflection,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection({required this.entries});

  final List<ActivityEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Recent activities',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        ...entries.map(
          (a) => ListTile(
            dense: true,
            leading: Icon(
              a.mediaUrl != null ? Icons.link : Icons.article_outlined,
              size: 20,
            ),
            title: Text(a.type),
            subtitle: Text(
              a.description.isEmpty ? '—' : a.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
