import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../providers/gamification_provider.dart';

class SessionCompleteScreen extends StatefulWidget {
  const SessionCompleteScreen({super.key});

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen> {
  XFile? _mediaFile; // Switched from File to cross-platform XFile
  bool _isUploading = false;
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Select Photo from Gallery or Camera
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _mediaFile = pickedFile; // Save directly as XFile without converting to dart:io File
      });
    }
  }

  void _clearMedia() {
    setState(() {
      _mediaFile = null;
    });
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Select Photo Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryGreen),
              title: const Text('Photo from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primaryGreen),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Submission logic
  Future<void> _submitSession() async {
    if (_commentController.text.isEmpty && _mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reflection or upload proof.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final firestoreService = FirestoreService();
      final storageService = StorageService();
      final gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);

      String? downloadUrl;
      final uid = firestoreService.uid;
      if (uid == null) throw Exception("User not logged in");

      // Upload the image to Firebase Storage
      if (_mediaFile != null) {
        final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${_mediaFile!.name}";

        if (kIsWeb) {
          // 🌐 Web specific upload using raw bytes
          final Uint8List bytes = await _mediaFile!.readAsBytes();
          downloadUrl = await storageService.uploadActivityMedia(
            uid: uid,
            fileName: fileName,
            fileBytes: bytes, // Successfully uses the 'bytes' variable to solve the warning
          );
        } else {
          // 📱 Mobile native safe upload using the file path string
          downloadUrl = await storageService.uploadActivityMedia(
            uid: uid,
            fileName: fileName,
            filePath: _mediaFile!.path,
          );
        }
      }

      // Log Activity to Firestore
      await firestoreService.logFocusSession(
        durationMinutes: 0,
        xpEarned: 50,
        tag: "Offline Activity: ${_commentController.text}",
        mediaUrl: downloadUrl,
      );

      // Award XP to the local Gamification State
      gamificationProvider.addXp(50);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity Logged! You earned 50 XP.')));

      _clearMedia();
      _commentController.clear();
      Navigator.pushReplacementNamed(context, '/mood_logging');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Log Offline Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Activity Evidence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _isUploading ? null : _showPickerOptions,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: .5)),
                ),
                child: _mediaFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  // Web displays image via network Blob object URL, Mobile renders via file conversion
                  child: kIsWeb
                      ? Image.network(_mediaFile!.path, fit: BoxFit.cover)
                      : Image.file(File(_mediaFile!.path), fit: BoxFit.cover),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text('Tap to select photo', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            if (_mediaFile != null)
              TextButton.icon(
                onPressed: _clearMedia,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Remove selected photo', style: TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            const Text('Personal Reflection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              enabled: !_isUploading,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _submitSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBMIT & EARN XP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}