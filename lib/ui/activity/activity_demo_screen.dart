import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/locale_controller.dart';
import '../../models/activity_entry.dart';
import '../../state/app_data_provider.dart';

/// Activity log form + optional media URL (no upload yet).
class ActivityDemoScreen extends StatefulWidget {
  const ActivityDemoScreen({super.key});

  @override
  State<ActivityDemoScreen> createState() => _ActivityDemoScreenState();
}

class _ActivityDemoScreenState extends State<ActivityDemoScreen> {
  final _type = TextEditingController(text: 'Study');
  final _desc = TextEditingController();
  final _url = TextEditingController();

  @override
  void dispose() {
    _type.dispose();
    _desc.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF46AA57);
    final tr = context.watch<LocaleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        backgroundColor: accent,
        automaticallyImplyLeading: false,
        title: Text(tr.activityTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(tr.activityType, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _type,
            decoration: _dec(tr.activityTypeHint),
          ),
          const SizedBox(height: 16),
          Text(tr.activityContent, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _desc,
            maxLines: 3,
            decoration: _dec(tr.activityContentHint),
          ),
          const SizedBox(height: 16),
          Text(tr.activityMediaUrl, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _url,
            decoration: _dec(tr.activityMediaUrlHint),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final data = context.read<AppDataProvider>();
              final url = _url.text.trim();
              await data.addActivity(
                ActivityEntry(
                  id: const Uuid().v4(),
                  profileId: data.currentProfileId,
                  loggedAt: DateTime.now(),
                  type: _type.text.trim().isEmpty ? 'General' : _type.text.trim(),
                  description: _desc.text.trim(),
                  mediaUrl: url.isEmpty ? null : url,
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr.activitySaved)),
                );
                _desc.clear();
                _url.clear();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(tr.activitySubmit),
          ),
          const SizedBox(height: 28),
          Text(tr.activityRecent, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Consumer<AppDataProvider>(
            builder: (context, data, _) {
              final list = data.activities.take(8).toList();
              if (list.isEmpty) {
                return Text(tr.activityNone, style: TextStyle(color: Colors.grey.shade600));
              }
              return Column(
                children: list
                    .map(
                      (a) => Card(
                        child: ListTile(
                          title: Text(a.type),
                          subtitle: Text(
                            a.description.isEmpty ? '—' : a.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: a.mediaUrl != null ? const Icon(Icons.link) : null,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  static InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
