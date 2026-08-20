import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

import '../../core/constants/app_colors.dart';

class MoodLoggingPage extends StatefulWidget {
  const MoodLoggingPage({super.key});

  @override
  State<MoodLoggingPage> createState() => _MoodLoggingPageState();
}

class _MoodLoggingPageState extends State<MoodLoggingPage> {
  int selectedMood = 2;// Default to "Normal" (Index 2)

  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _reflectionController = TextEditingController();
  bool _isSaving = false;

  final List<IconData> moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final List<Color> moodColors = [
    Colors.red,
    Colors.deepOrange,
    Colors.yellow.shade700,
    Colors.lightGreen,
    Colors.green,
  ];

  final List<String> moodTexts = [
    "I feel very sad!",
    "I feel a bit down!",
    "I feel normal!",
    "I feel good!",
    "I feel great!",
  ];

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  // Syncs with FirestoreService for TSV Export
  Future<void> _saveMoodToFirebase() async {
    if (_firestoreService.uid == null) return;

    setState(() => _isSaving = true);
    try {
      // Call the centralized service method
      await _firestoreService.logMood(
        moodIndex: selectedMood,
        reflection: _reflectionController.text.isNotEmpty
            ? _reflectionController.text
            : moodTexts[selectedMood], // Default reflection if empty
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mood saved: ${moodTexts[selectedMood]}")),
      );

      _reflectionController.clear(); // Clear input after successful save

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving mood: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text("Mood Logging",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            Center(
              child: Icon(
                moodIcons[selectedMood],
                key: ValueKey<int>(selectedMood),
                color: moodColors[selectedMood],
                size: 120,
              ),
            ),
            const SizedBox(height: 30),

            // Horizontal Mood Selector Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(moodIcons.length, (index) {
                bool isSelected = index == selectedMood;
                return GestureDetector(
                  onTap: () => setState(() => selectedMood = index),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 1.3 : 1.0,
                    child: Icon(moodIcons[index], color: moodColors[index], size: 48),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Reflection Input
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Reflections", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reflectionController,
              maxLines: 3,
              enabled: !_isSaving,
              decoration: InputDecoration(
                hintText: "Why do you feel this way? Share your thoughts...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),

            // Save Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveMoodToFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  moodTexts[selectedMood], // Displays corresponding mood text
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}