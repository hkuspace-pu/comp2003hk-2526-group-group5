import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../services/notification_service.dart';
import 'user_profile_screen.dart';
import 'family_leaderboard.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color themeGreen = AppColors.primaryGreen;
  String _reminderTimeText = 'Not Set'; // To show selected time in UI

  @override
  void initState() {
    super.initState();
    _loadSavedReminderTime(); // Load time when page opens
  }

  // Load saved time from SharedPreferences
  Future<void> _loadSavedReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt('reminder_hour');
    final int? minute = prefs.getInt('reminder_minute');
    if (hour != null && minute != null) {
      setState(() {
        _reminderTimeText = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      });
    }
  }

  // Show TimePicker and Schedule Notification
  Future<void> _updateFocusReminder(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 09, minute: 00),
    );

    if (picked != null) {
      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminder_hour', picked.hour);
      await prefs.setInt('reminder_minute', picked.minute);

      // Schedule via Service
      await NotificationService().scheduleDailyFocusReminder(
        hour: picked.hour,
        minute: picked.minute,
      );

      setState(() {
        _reminderTimeText = picked.format(context);
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Focus reminder set for $_reminderTimeText')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: themeGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: themeGreen));
          }

          final auth.User? user = auth.FirebaseAuth.instance.currentUser;
          if (user == null) {
            return const Center(child: Text("Please log in to see settings."));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            children: [
              UserProfileTile(
                name: userProvider.userProfile?.name ?? "Focus User",
                email: user.email ?? "No Email Attached",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
                },
              ),
              const SizedBox(height: 20),

              // General Settings
              SettingsGroup(
                title: 'General',
                items: [
                  SettingItem(
                    icon: Icons.alarm,
                    title: 'Daily Focus Reminder',
                    trailingText: _reminderTimeText,
                    onTap: () => _updateFocusReminder(context),
                  ),
                  const SettingItem(icon: Icons.language, title: 'Language', trailingText: 'English'),
                ],
              ),
              const SizedBox(height: 20),

              //  Account & Security
              SettingsGroup(
                title: 'Account & Security',
                items: [
                  SettingItem(
                    icon: Icons.group_add_outlined,
                    title: 'Family Group',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyLeaderboard()));
                    },
                  ),
                  const SettingItem(icon: Icons.lock_outline, title: 'Privacy Policy'),
                  const SettingItem(icon: Icons.verified_user_outlined, title: 'Security'),
                ],
              ),
              const SizedBox(height: 16),

              const SettingsGroup(
                title: 'Support',
                items: [
                  SettingItem(icon: Icons.info_outline, title: 'App Version', trailingText: '1.2.0'),
                  SettingItem(icon: Icons.help_outline, title: 'Help Center'),
                ],
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context, userProvider),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}


// UI Helper Components

class UserProfileTile extends StatelessWidget {
  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback onTap;

  const UserProfileTile({super.key, required this.name, required this.email, this.photoUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primaryGreen.withValues(alpha: .1),
          backgroundImage: const AssetImage('images/profile.png'),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(email, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingItem> items;
  const SettingsGroup({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(title.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE)),
                bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingItem({super.key, required this.icon, required this.title, this.trailingText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText!, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}