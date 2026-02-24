import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Session Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SessionCompleteScreen(),
    );
  }
}

class SessionCompleteScreen extends StatefulWidget {
  const SessionCompleteScreen({super.key});

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen> {
  // We cannot use `image_picker` as it is not an allowed package.
  // We will simulate media upload by allowing the user to "add" or "remove"
  // a placeholder image from a network URL.
  String? _selectedMediaUrl; // Holds the URL of the placeholder image
  bool _isMediaAdded = false; // Tracks if the placeholder media is "added"
  final TextEditingController _commentController = TextEditingController();

  // Toggles the presence of the placeholder media.
  void _togglePlaceholderMedia() {
    setState(() {
      _isMediaAdded = !_isMediaAdded;
      // Set the placeholder URL if media is added, otherwise set to null.
      _selectedMediaUrl = _isMediaAdded
          ? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'
          : null;
    });
  }

  void _submitSession() {
    // In a real application, you would send _selectedMediaUrl and _commentController.text
    // to a backend service. Here, we just show a confirmation snackbar.
    final String mediaStatus =
    _isMediaAdded ? 'with placeholder media' : 'without media';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Session submitted $mediaStatus and comment: "${_commentController.text}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Session Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white, // Sets color for title and icons
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Upload section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Upload an image or video',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap:
                    _togglePlaceholderMedia, // Use the new toggle method
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isMediaAdded
                              ? Colors.green
                              : Colors.grey, // Border color based on media presence
                          width: 2,
                        ),
                      ),
                      child: _isMediaAdded
                          ? Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              _selectedMediaUrl!, // Display the placeholder network image
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 24,
                              ),
                              onPressed: _togglePlaceholderMedia,
                              tooltip: 'Remove Media',
                            ),
                          ),
                        ],
                      )
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap to add placeholder media', // Clarified text
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Comments section
            const Text(
              'Any comments?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your comments here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}