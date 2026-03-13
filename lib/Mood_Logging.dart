import 'package:flutter/material.dart';

void main() {
  runApp(const MoodLoggingApp());
}

class MoodLoggingApp extends StatelessWidget {
  const MoodLoggingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Logging',
      debugShowCheckedModeBanner: false,
      home: const MoodLoggingPage(),
    );
  }
}

class MoodLoggingPage extends StatefulWidget {
  const MoodLoggingPage({super.key});

  @override
  State<MoodLoggingPage> createState() => _MoodLoggingPageState();
}

class _MoodLoggingPageState extends State<MoodLoggingPage> {
  int selectedMood = 2;
  int _selectedIndex = 0;

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
    "I feel very sad!",
    "I feel a bit down!",
    "I feel normal!",
    "I feel good!",
    "I feel great!",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF46AA57),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          "Mood Logging",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "How is your mood today?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // BIG ICON (selected mood)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                moodIcons[selectedMood],
                key: ValueKey<int>(selectedMood),
                color: moodColors[selectedMood],
                size: 120,
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 20,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main horizontal line
                      Container(
                        height: 15.0,
                        color: Colors.lightBlue.shade300,
                      ),

                      // Vertical tick marks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(moodIcons.length, (index) {
                          return Container(
                            width: 2,
                            height: 12,
                            color: Colors.blueAccent.withAlpha((255 * 0.7).round()),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(moodIcons.length, (index) {
                    return index == selectedMood
                        ? const Icon(Icons.arrow_downward,
                        size: 22, color: Colors.blueAccent)
                        : const SizedBox(width: 48);
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(moodIcons.length, (index) {
                    bool isSelected = index == selectedMood;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = index;
                        });
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isSelected ? 1.3 : 1.0,
                        child: Icon(
                          moodIcons[index],
                          color: moodColors[index],
                          size: 48,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Mood saved: ${moodTexts[selectedMood]}",
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
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
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.area_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}