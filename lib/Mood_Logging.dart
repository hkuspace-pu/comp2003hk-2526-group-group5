import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'models/mood_entry.dart';
import 'state/app_data_provider.dart';

class MoodLoggingPage extends StatefulWidget {
  const MoodLoggingPage({super.key});

  @override
  State<MoodLoggingPage> createState() => _MoodLoggingPageState();
}

class _MoodLoggingPageState extends State<MoodLoggingPage> {
  int selectedMood = 2;
  final _reflection = TextEditingController();

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
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
  ];

  final List<String> moodTexts = [
    'I feel very sad!',
    'I feel a bit down!',
    'I feel normal!',
    'I feel good!',
    'I feel great!',
  ];

  @override
  void dispose() {
    _reflection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF46AA57),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Mood Logging',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          const Text(
            'How is your mood today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                moodIcons[selectedMood],
                key: ValueKey<int>(selectedMood),
                color: moodColors[selectedMood],
                size: 100,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(moodIcons.length, (index) {
              final isSelected = index == selectedMood;
              return GestureDetector(
                onTap: () => setState(() => selectedMood = index),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.25 : 1.0,
                  child: Icon(
                    moodIcons[index],
                    color: moodColors[index],
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text('Reflection', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _reflection,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '寫幾句今日感受…',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final data = context.read<AppDataProvider>();
                await data.addMood(
                  MoodEntry(
                    id: const Uuid().v4(),
                    profileId: data.currentProfileId,
                    loggedAt: DateTime.now(),
                    moodIndex: selectedMood,
                    reflection: _reflection.text.trim(),
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已記錄：${moodTexts[selectedMood]}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46AA57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                moodTexts[selectedMood],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text('Mood 紀錄', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Consumer<AppDataProvider>(
            builder: (context, data, _) {
              final list = data.moods.take(10).toList();
              if (list.isEmpty) {
                return Text('暫無紀錄', style: TextStyle(color: Colors.grey.shade600));
              }
              return Column(
                children: list.map((m) {
                  return Card(
                    child: ListTile(
                      leading: Icon(moodIcons[m.moodIndex], color: moodColors[m.moodIndex]),
                      title: Text(moodTexts[m.moodIndex]),
                      subtitle: Text(
                        m.reflection.isEmpty ? '（無 reflection）' : m.reflection,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
