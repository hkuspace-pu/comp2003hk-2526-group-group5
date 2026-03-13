import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final ImageProvider? customerImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.customerImage,
  });
}

/// Manages authentication credentials for specific actions.
class AuthData extends ChangeNotifier {
  // Hardcoded credentials for the 'Jeremy Lee' user
  final String _correctEmail = 'jeremy.lee@example.com';
  final String _correctPassword = 'password123';

  /// Authenticates a user with the given email and password.
  /// Simulates a network call for authentication.
  /// Returns true if credentials match, false otherwise.
  Future<bool> login({required String email, required String password}) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return email == _correctEmail && password == _correctPassword;
  }
}

/// Manages gamification data.
class GamificationData extends ChangeNotifier {
  static const String _placeholderImageUrl =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  DateTime? _gamificationStartDate;
  int _totalXp = 0;
  int _currentLevel = 0;

  int get currentXp => _totalXp;
  int get currentLevel => _currentLevel;
  DateTime get gamificationStartDate => _gamificationStartDate ?? DateTime.now();

  GamificationData() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadFromStorage();
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _gamificationStartDate = DateTime.fromMillisecondsSinceEpoch(
      prefs.getInt('gamificationStartTime') ??
          DateTime.now().millisecondsSinceEpoch,
    );
    _totalXp = prefs.getInt('totalXp') ?? 1500;
    _currentLevel = prefs.getInt('currentLevel') ?? 4;
  }

  Future<void> _saveToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'gamificationStartTime', gamificationStartDate.millisecondsSinceEpoch);
    await prefs.setInt('totalXp', _totalXp);
    await prefs.setInt('currentLevel', _currentLevel);
  }

  Future<void> addFocusTime(Duration sessionDuration,
      {int xpPerMinute = 5}) async {
    final int xpGained = (sessionDuration.inMinutes * xpPerMinute).toInt();
    await addXp(xpGained);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> addXp(int xp) async {
    _totalXp += xp;
    _updateLevel();
  }

  void _updateLevel() {
    _currentLevel = (_totalXp / 250).floor().clamp(0, 10);
  }

  int get totalItemsCollected => 0;

  String get timeSpentString {
    final Duration duration = DateTime.now().difference(gamificationStartDate);
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    final int minutes = duration.inMinutes.remainder(60);

    final List<String> parts = <String>[];
    if (days > 0) parts.add('$days day${days == 1 ? '' : 's'}');
    if (hours > 0) parts.add('$hours hour${hours == 1 ? '' : 's'}');
    if (minutes > 0) parts.add('$minutes minute${minutes == 1 ? '' : 's'}');

    return parts.isEmpty ? 'Just started!' : parts.join(', ');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<GamificationData>(
            create: (BuildContext context) => GamificationData()),
        ChangeNotifierProvider<AuthData>(
            create: (BuildContext context) => AuthData()),
      ],
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User Profile - Gamification',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(elevation: 0),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(secondary: Colors.grey.shade600),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const UserProfileScreen(),
      ),
    ),
  );
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nav item ${index + 1}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF46AA57);

    return Consumer<GamificationData>(
      builder: (BuildContext context, GamificationData gamificationData, _) =>
          Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Root screen')),
                ),
              ),
              title: const Text('Account', style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: <Widget>[
                // Profile Header and Stats combined
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: const AssetImage('images/profile.png'),
                          ),
                          const SizedBox(height: 16),
                          const Text('Jeremy Lee',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.access_time,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(width: 4),
                              Text(gamificationData.timeSpentString,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _StatColumn(
                                icon: Icons.star,
                                value: gamificationData.currentXp.toString(),
                                label: 'XP',
                                color: Theme.of(context).primaryColor,
                              ),
                              _StatColumn(
                                icon: Icons.leaderboard,
                                value: gamificationData.currentLevel.toString(),
                                label: 'Level',
                                color: Colors.blueAccent,
                              ),
                              _StatColumn(
                                icon: Icons.category,
                                value:
                                gamificationData.totalItemsCollected.toString(),
                                label: 'Items',
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _SettingsGroup(title: 'Account Management', options: <Widget>[
                  ListTile(
                      title: const Text('Account Management'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account Mgmt')))),
                ]),
                const SizedBox(height: 16),
                _SettingsGroup(title: 'Export Your Data', options: <Widget>[
                  ListTile(
                      title: const Text('Export Your Data'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final bool? success = await Navigator.of(context).push<bool>(
                          MaterialPageRoute<bool>(
                            builder: (BuildContext context) =>
                            const ExportLoginScreen(),
                          ),
                        );
                        if (success == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Data Export initiated successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Data Export cancelled or failed.')),
                          );
                        }
                      }),
                ]),
                const SizedBox(height: 80),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.event), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.area_chart), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: appBarColor,
              unselectedItemColor: Colors.grey.shade700,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SettingsGroupTitle extends StatelessWidget {
  final String title;
  const _SettingsGroupTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> options;
  const _SettingsGroup(
      {super.key, required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final List<Widget> childrenWithDividers = <Widget>[];
    for (int i = 0; i < options.length; i++) {
      childrenWithDividers.add(options[i]);
      if (i < options.length - 1) {
        childrenWithDividers.add(const Divider(
            height: 1, thickness: 1, indent: 16, endIndent: 16));
      }
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SettingsGroupTitle(title: title),
          Container(
              color: Colors.white, child: Column(children: childrenWithDividers)),
        ]);
  }
}

class ExportLoginScreen extends StatefulWidget {
  const ExportLoginScreen({super.key});

  @override
  State<ExportLoginScreen> createState() => _ExportLoginScreenState();
}

class _ExportLoginScreenState extends State<ExportLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password cannot be empty.';
        _isLoading = false;
      });
      return;
    }

    final AuthData authData = Provider.of<AuthData>(context, listen: false);
    final bool success = await authData.login(email: email, password: password);

    if (success) {
      Navigator.of(context).pop(true); // Pop with success indicator
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticate for Export'),
        backgroundColor: const Color(0xFF46AA57),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle:
        Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Please authenticate to proceed with data export.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            if (_errorMessage != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _attemptLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Pop with failure/cancel indicator
              },
              child: Text(
                'Cancel',
                style:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}