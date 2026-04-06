import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'Gamification.dart';
import 'state/app_data_provider.dart';
import 'state/user_provider.dart';

class SettingsGroupTitle extends StatelessWidget {
  final String title;
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

class UserProfileTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserProfileTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.customerImage,
          child: user.customerImage == null
              ? Text(user.name[0].toUpperCase())
              : null,
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

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> options;

  const SettingsGroup({super.key, required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final List<Widget> childrenWithDividers = [];
    for (int i = 0; i < options.length; i++) {
      childrenWithDividers.add(options[i]);
      if (i < options.length - 1) {
        childrenWithDividers.add(
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsGroupTitle(title: title),
        Container(
          color: Colors.white,
          child: Column(children: childrenWithDividers),
        ),
      ],
    );
  }
}

/// Main settings page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifDemo = false;
  bool _breakDemo = false;

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF46AA57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userProvider.currentUser;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No user logged in'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        userProvider.login('test@example.com', 'password'),
                    child: const Text('Log In (Demo)'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              UserProfileTile(
                user: user,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User profile tapped')),
                  );
                },
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: '提醒',
                options: [
                  SwitchListTile(
                    secondary: const Icon(Icons.play_circle_outline),
                    title: const Text('專注開始提醒'),
                    subtitle: const Text('之後可接本地通知'),
                    value: _notifDemo,
                    activeThumbColor: appBarColor,
                    onChanged: (v) {
                      setState(() => _notifDemo = v);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(v ? '已開啟' : '已關閉')),
                      );
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.coffee_outlined),
                    title: const Text('休息提醒'),
                    subtitle: const Text('本地提醒占位'),
                    value: _breakDemo,
                    activeThumbColor: appBarColor,
                    onChanged: (v) => setState(() => _breakDemo = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<AppDataProvider>(
                builder: (context, appData, _) {
                  return SettingsGroup(
                    title: 'Profile',
                    options: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: appData.profiles
                              .map(
                                (p) => FilterChip(
                                  label: Text(p.name),
                                  selected: p.id == appData.currentProfileId,
                                  onSelected: (_) => appData.switchProfile(p.id),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_add_alt_1),
                        title: const Text('新增 profile'),
                        onTap: () async {
                          await appData.addProfile('Profile ${appData.profiles.length + 1}');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('已新增 profile')),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: 'Account Settings',
                options: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Security settings')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change password')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: '資料',
                options: [
                  ListTile(
                    leading: const Icon(Icons.upload_file),
                    title: const Text('匯出 TSV'),
                    subtitle: const Text('之後接真檔案'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('匯出 — 功能稍後接')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('匯入 TSV'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('匯入 — 功能稍後接')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline),
                    title: const Text('Health（mock）'),
                    subtitle: const Text('預覽：今日步數 6234'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Apple Health / Google Fit 之後接')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Share city'),
                    subtitle: const Text('Share your progress as text'),
                    onTap: () async {
                      final gamification =
                          Provider.of<GamificationData>(context, listen: false);
                      await Share.share(
                        'My Focus City — Level ${gamification.currentCurrentLevel}, '
                        'Total XP: ${gamification.currentTotalXp}. '
                        'Built with Focus Wellbeing!',
                        subject: 'My Focus City',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: 'About App',
                options: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Version'),
                    trailing: const Text('1.0.0'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App version info')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: userProvider.isLoading
                      ? null
                      : () => userProvider.logout(),
                  child: const Text(
                    'Log Out',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
