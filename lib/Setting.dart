import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Future.delayed

import 'main_shell_insets.dart';
import 'screens/main/settings_subpages.dart';

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

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  UserProvider() {
    // Initialize with a demo user
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee',
      email: 'jeremy.lee@example.com',
      customerImage: const AssetImage('images/profile.png'),
    );
  }

  /// Currently logged‑in user
  User? get currentUser => _currentUser;

  /// Whether an async operation is running
  bool get isLoading => _isLoading;

  /// Simulated login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee',
      email: email,
      customerImage: const AssetImage('images/profile.png'),
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Simulated logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }
}

const Color _kBrandGreen = Color(0xFF46AA57);
const Color _kCream = Color(0xFFF8F8EC);

class SettingsGroupTitle extends StatelessWidget {
  final String title;
  const SettingsGroupTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// Rounded icon chip for settings rows (matches Dashboard / Focus styling).
class SettingsLeadingIcon extends StatelessWidget {
  const SettingsLeadingIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _kBrandGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 22, color: _kBrandGreen),
    );
  }
}

class UserProfileTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserProfileTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _kBrandGreen.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: _kCream,
                    backgroundImage: user.customerImage,
                    child: user.customerImage == null
                        ? Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: _kBrandGreen,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Account & profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kBrandGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> options;

  const SettingsGroup({super.key, required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SettingsGroupTitle(title: title),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                for (int i = 0; i < options.length; i++) ...<Widget>[
                  if (i > 0)
                    Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                  options[i],
                ],
              ],
            ),
          ),
        ],
    );
  }
}

/// Main settings page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.embedded = false});

  /// When true, used inside [MainShellScreen] (no duplicate app bar / bottom nav).
  final bool embedded;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bottom nav item tapped: ${index + 1}')),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = _kBrandGreen;

    final Widget body = Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, _) {
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _kBrandGreen),
          );
        }

        final User? user = userProvider.currentUser;
        if (user == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_off_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No account loaded',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in from the welcome screen, or continue below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.35),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () =>
                        userProvider.login('test@example.com', 'password'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _kBrandGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(
            12,
            kMainTabScrollPadding.top,
            12,
            kMainTabScrollPadding.bottom,
          ),
          children: <Widget>[
            UserProfileTile(
              user: user,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const AccountDetailPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SettingsGroup(
              title: 'General',
              options: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.notifications_outlined),
                  title: Text(
                    'Notifications',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Reminders & alerts',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const NotificationSettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.language_rounded),
                  title: Text(
                    'Language',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'App display language',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () => _snack(
                    context,
                    'Language options will be available soon.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              title: 'Account',
              options: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.privacy_tip_outlined),
                  title: Text(
                    'Privacy',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Data & visibility',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () => _snack(context, 'Privacy settings'),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.shield_outlined),
                  title: Text(
                    'Security',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Devices & sign-in',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () => _snack(context, 'Security settings'),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.lock_outline_rounded),
                  title: Text(
                    'Change password',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Update your password',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () => _snack(context, 'Change password'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              title: 'Data & sharing',
              options: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.import_export_rounded),
                  title: Text(
                    'Export / import',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Backup your progress',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ExportImportPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.share_rounded),
                  title: Text(
                    'Share city',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Post your city to social',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const ShareCityPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              title: 'About',
              options: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.info_outline_rounded),
                  title: Text(
                    'Version',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Build & updates',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kCream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Text(
                      '1.0.0',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _kBrandGreen,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  onTap: () => _snack(context, 'Build 1.0.0'),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const SettingsLeadingIcon(icon: Icons.help_outline_rounded),
                  title: Text(
                    'Help & support',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'FAQs & contact',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                  onTap: () => _snack(context, 'Help & support'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
                onPressed: userProvider.isLoading ? null : () => userProvider.logout(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade200),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 22),
                label: const Text(
                  'Sign out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            const SizedBox(height: 12),
          ],
        );
      },
    );

    if (widget.embedded) {
      return ColoredBox(
        color: _kCream,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: _kCream,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
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
    );
  }
}
