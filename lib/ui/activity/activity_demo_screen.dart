import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/locale_controller.dart';
import '../../models/activity_entry.dart';
import '../../state/app_data_provider.dart';

/// Activity log with optional media URL or imported image file (stored as data URL).
class ActivityDemoScreen extends StatefulWidget {
  const ActivityDemoScreen({super.key});

  @override
  State<ActivityDemoScreen> createState() => _ActivityDemoScreenState();
}

class _ActivityDemoScreenState extends State<ActivityDemoScreen> {
  final _type = TextEditingController(text: 'Study');
  final _desc = TextEditingController();
  final _url = TextEditingController();

  /// In-memory data URL (`data:image/...;base64,...`) from [FilePicker].
  String? _pickedDataUrl;
  String? _pickedFileName;

  static const int _maxImageBytes = 4 * 1024 * 1024;

  @override
  void dispose() {
    _type.dispose();
    _desc.dispose();
    _url.dispose();
    super.dispose();
  }

  Future<void> _pickImageFile() async {
    final tr = context.read<LocaleController>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.single;
    final bytes = picked.bytes;
    if (bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.activityPickFileError)),
        );
      }
      return;
    }
    if (bytes.length > _maxImageBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.activityFileTooLarge)),
        );
      }
      return;
    }
    final name = picked.name.toLowerCase();
    final mime = name.endsWith('.png')
        ? 'image/png'
        : name.endsWith('.webp')
            ? 'image/webp'
            : 'image/jpeg';
    final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
    setState(() {
      _pickedDataUrl = dataUrl;
      _pickedFileName = picked.name;
    });
  }

  void _clearPickedFile() {
    setState(() {
      _pickedDataUrl = null;
      _pickedFileName = null;
    });
  }

  String? _mediaForSubmit() {
    final url = _url.text.trim();
    if (url.isNotEmpty) return url;
    if (_pickedDataUrl != null) return _pickedDataUrl;
    return null;
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
          const SizedBox(height: 16),
          Text(tr.activityMediaFile, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickImageFile,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(tr.activityPickFile),
          ),
          if (_pickedFileName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _pickedFileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _clearPickedFile,
                  child: Text(tr.activityClearFile),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final data = context.read<AppDataProvider>();
              final media = _mediaForSubmit();
              await data.addActivity(
                ActivityEntry(
                  id: const Uuid().v4(),
                  profileId: data.currentProfileId,
                  loggedAt: DateTime.now(),
                  type: _type.text.trim().isEmpty ? 'General' : _type.text.trim(),
                  description: _desc.text.trim(),
                  mediaUrl: media,
                ),
              );
              if (context.mounted) {
                final msg = context.read<LocaleController>().activitySaved;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
                _desc.clear();
                _url.clear();
                _clearPickedFile();
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
                          trailing: _mediaThumb(a.mediaUrl),
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

  static Widget? _mediaThumb(String? mediaUrl) {
    if (mediaUrl == null || mediaUrl.isEmpty) return null;
    if (mediaUrl.startsWith('data:image')) {
      final comma = mediaUrl.indexOf(',');
      if (comma == -1) return const Icon(Icons.image);
      try {
        final bytes = base64Decode(mediaUrl.substring(comma + 1));
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.memory(
            bytes,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        return const Icon(Icons.broken_image_outlined);
      }
    }
    if (mediaUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          mediaUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.link),
        ),
      );
    }
    return const Icon(Icons.attach_file);
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
