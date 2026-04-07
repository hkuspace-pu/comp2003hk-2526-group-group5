import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../main_shell_insets.dart';
import 'staff_end_user.dart';
import 'staff_sample_users.dart';
import 'staff_theme.dart';

/// Searchable directory of end users (sample data).
class StaffUserListTab extends StatefulWidget {
  const StaffUserListTab({super.key});

  @override
  State<StaffUserListTab> createState() => _StaffUserListTabState();
}

class _StaffUserListTabState extends State<StaffUserListTab> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<StaffEndUser> _filtered() {
    final String q = _query.text.trim().toLowerCase();
    final List<StaffEndUser> all = staffSampleEndUsers();
    if (q.isEmpty) return all;
    return all
        .where(
          (StaffEndUser u) =>
              u.displayName.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.id.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openDetail(StaffEndUser u) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: StaffTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                u.displayName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: StaffTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                u.email,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
              const SizedBox(height: 16),
              _DetailRow(label: l10n.staffUserId, value: u.id),
              _DetailRow(label: l10n.levelLabel, value: '${u.level}'),
              _DetailRow(label: l10n.totalXpLabel, value: '${u.totalXp}'),
              _DetailRow(label: l10n.staffLastActive, value: u.lastActiveLabel),
              _DetailRow(
                label: l10n.staffFocusThisWeek,
                value: l10n.focusMinutesValue(u.focusMinutesThisWeek),
              ),
              _DetailRow(label: l10n.staffStatus, value: u.statusLabel),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.closeLabel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<StaffEndUser> rows = _filtered();

    return ColoredBox(
      color: StaffTheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              kMainTabScrollPadding.left,
              kMainTabScrollPadding.top,
              kMainTabScrollPadding.right,
              8,
            ),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.staffSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: StaffTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                kMainTabScrollPadding.left,
                0,
                kMainTabScrollPadding.right,
                kMainTabScrollPadding.bottom,
              ),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int i) {
                final StaffEndUser u = rows[i];
                final String initial = u.displayName.isNotEmpty
                    ? u.displayName[0].toUpperCase()
                    : '?';
                return Material(
                  color: StaffTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openDetail(u),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor:
                                StaffTheme.primary.withValues(alpha: 0.12),
                            foregroundColor: StaffTheme.primary,
                            child: Text(
                              initial,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  u.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  u.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  u.lastActiveLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: u.statusLabel == 'Active'
                                  ? StaffTheme.accent.withValues(alpha: 0.12)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              u.statusLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: u.statusLabel == 'Active'
                                    ? StaffTheme.accent
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
