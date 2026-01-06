import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Future.delayed

/// Data model for a User.
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  /// Initializes a [User] with required details and an optional avatar URL.
  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}

/// [ChangeNotifier] that manages the current user's state.
class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  /// Initializes the provider, optionally with a dummy logged-in user.
  UserProvider() {
    // Initialize with a dummy logged-in user for demonstration purposes.
    // Set avatarUrl to a placeholder image to match the profile picture in the image.
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee',
      email: 'jeremy.lee@example.com',
      avatarUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', // Placeholder for avatar
    );
    // To start with no user logged in, uncomment the line below and comment the above:
    // _currentUser = null;
  }

  /// Returns the currently logged-in user.
  User? get currentUser => _currentUser;

  /// Indicates if an asynchronous operation (like login/logout) is in progress.
  bool get isLoading => _isLoading;

  /// Simulates a user login operation.
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network request delay

    // Simulate successful login with a dummy user and placeholder avatar.
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee', // Consistent name for logged-in user
      email: email,
      avatarUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    );
    _isLoading = false;
    notifyListeners();
  }

  /// Simulates a user logout operation.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network request delay

    _currentUser = null; // Set current user to null upon logout.
    _isLoading = false;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

/// The root widget for the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) => UserProvider(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Settings App',
          theme: ThemeData(
            primarySwatch: Colors.teal, // A pleasant primary color for the app
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              elevation: 0, // Remove shadow for a flat design
            ),
            // Define a secondary color for text, e.g., for group titles
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                .copyWith(secondary: Colors.grey.shade600),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey background
          ),
          home: const SettingsPage(),
        );
      },
    );
  }
}

/// A helper widget to display titles for sections of settings.
class SettingsGroupTitle extends StatelessWidget {
  final String title;

  /// Creates a [SettingsGroupTitle] with the given [title].
  const SettingsGroupTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Widget to display a user's profile information as a list tile.
class UserProfileTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserProfileTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // White background for the profile tile
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          // Display user's avatar or a placeholder image if not available.
          backgroundImage: NetworkImage(
            user.avatarUrl ?? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
          ),
        ),
        title: Text(user.name),
        subtitle: Text(
          user.email,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// A widget that groups a set of settings options under a title.
class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> options; // List of widgets (e.g., ListTiles) for this group

  const SettingsGroup({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    // Generate children with dividers in between options
    final List<Widget> childrenWithDividers = <Widget>[];
    for (int i = 0; i < options.length; i++) {
      childrenWithDividers.add(options[i]);
      if (i < options.length - 1) {
        childrenWithDividers.add(const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsGroupTitle(title: title),
        Container(
          color: Colors.white,
          child: Column(
            children: childrenWithDividers,
          ),
        ),
      ],
    );
  }
}

/// The main settings page of the application.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C6D5A), // Custom green for AppBar
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white), // White title text
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // Close button
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userProvider, Widget? _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          final User? user = userProvider.currentUser;
          if (user == null) {
            // Display a message and a login button if no user is logged in
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('No user logged in'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userProvider.login('test@example.com', 'password'),
                    child: const Text('Log In (Demo)'),
                  ),
                ],
              ),
            );
          }

          // Display settings options when a user is logged in
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Overall vertical padding for the list
            children: <Widget>[
              // User Profile Section
              UserProfileTile(
                user: user,
                onTap: () {
                  // Navigate to the new UserProfileScreen when the tile is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => UserProfileScreen(user: user),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16), // Spacing before the next section

              // General Settings Section
              SettingsGroup(
                title: 'General Settings',
                options: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications settings')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Language settings')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account Settings Section
              SettingsGroup(
                title: 'Account Settings',
                options: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy settings')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Security settings')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change password')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // About App Section
              SettingsGroup(
                title: 'About App',
                options: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Version'),
                    trailing: const Text('1.0.0'), // Example version text
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App version info')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24), // Spacing before the logout button

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700, // Red background for logout
                    foregroundColor: Colors.white, // White text color
                    minimumSize: const Size.fromHeight(50), // Full width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  onPressed: userProvider.isLoading || userProvider.currentUser == null
                      ? null // Disable if loading or no user
                      : () => context.read<UserProvider>().logout(),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Spacing after the logout button
            ],
          );
        },
      ),
    );
  }
}

/// A new screen to display detailed user profile information.
class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 3; // Index for settings tab in bottom nav bar

  // Data for the profile metrics section
  final List<Map<String, dynamic>> _profileMetrics = <Map<String, dynamic>>[
    {'icon': Icons.forest_outlined, 'value': 12},
    {'icon': Icons.park_outlined, 'value': 2},
    {'icon': Icons.home_outlined, 'value': 9},
    {'icon': Icons.apartment_outlined, 'value': 5},
    {'icon': Icons.route_outlined, 'value': 2},
    {'icon': Icons.water_outlined, 'value': 1},
    {'icon': Icons.architecture_outlined, 'value': 3},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, this would navigate to different screens/tabs.
    // For this UI, it just changes the selected state visually.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bottom nav item tapped: ${index + 1}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF4CAF50); // Green color from image

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          // Profile Header Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 0, // Flat card
              margin: EdgeInsets.zero,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        widget.user.avatarUrl ?? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '2 Day 6 Hour 10 Minute', // Placeholder for activity time
                          style: TextStyle(
                              fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _profileMetrics.map<Widget>((Map<String, dynamic> metric) {
                        return _buildSmallMetricColumn(
                          context,
                          metric['value'] as int,
                          metric['icon'] as IconData,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Account Management Section
          SettingsGroup(
            title: 'Account Management',
            options: <Widget>[
              ListTile(
                title: const Text('Account Management'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigating to Account Management')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Export Data Section
          SettingsGroup(
            title: 'Export Your Data',
            options: <Widget>[
              ListTile(
                title: const Text('Export Your Data'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting user data')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 48), // Spacing before footer is removed
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all items are visible and fixed
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // Labels are not visible in the image
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), // Calendar with checkmark
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.area_chart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: appBarColor, // Green color for selected item
        unselectedItemColor: Colors.grey.shade700,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide labels to match image
        showUnselectedLabels: false, // Hide labels to match image
      ),
    );
  }

  // Helper widget to build a single metric column (e.g., 12, 2, 9)
  Widget _buildSmallMetricColumn(BuildContext context, int value, IconData iconData) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(iconData, color: Colors.grey.shade700, size: 28), // Icons are grey in the image
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}