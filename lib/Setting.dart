import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'Gamification.dart';
import 'l10n/locale_controller.dart';
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
        title: Consumer<LocaleController>(
          builder: (context, tr, _) => Text(
            tr.settingsTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<UserProvider, LocaleController>(
        builder: (context, userProvider, tr, _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userProvider.currentUser;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr.settingsNoUser),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        userProvider.login('test@example.com', 'password'),
                    child: Text(tr.settingsDemoLogin),
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
                    SnackBar(content: Text(tr.settingsUserProfileTap)),
                  );
                },
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: tr.settingsReminders,
                options: [
                  SwitchListTile(
                    secondary: const Icon(Icons.play_circle_outline),
                    title: Text(tr.settingsFocusStartReminder),
                    subtitle: Text(tr.settingsFocusStartReminderSub),
                    value: _notifDemo,
                    activeThumbColor: appBarColor,
                    onChanged: (v) {
                      setState(() => _notifDemo = v);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(v ? tr.settingsOn : tr.settingsOff)),
                      );
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.coffee_outlined),
                    title: Text(tr.settingsBreakReminder),
                    subtitle: Text(tr.settingsBreakReminderSub),
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
                    title: tr.settingsProfile,
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
                        title: Text(tr.settingsAddProfile),
                        onTap: () async {
                          await appData.addProfile('Profile ${appData.profiles.length + 1}');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(tr.settingsProfileAdded)),
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
                title: tr.settingsAccount,
                options: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: Text(tr.settingsPrivacy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsPrivacySnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(tr.settingsSecurity),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsSecuritySnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(tr.settingsChangePassword),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsPasswordSnack)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: tr.settingsData,
                options: [
                  ListTile(
                    leading: const Icon(Icons.upload_file),
                    title: Text(tr.settingsExportTsv),
                    subtitle: Text(tr.settingsExportTsvSub),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsExportSnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: Text(tr.settingsImportTsv),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsImportSnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline),
                    title: Text(tr.settingsHealthMock),
                    subtitle: Text(tr.settingsHealthMockSub),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsHealthSnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: Text(tr.settingsShareCity),
                    subtitle: Text(tr.settingsShareCitySub),
                    onTap: () async {
                      final gamification =
                          Provider.of<GamificationData>(context, listen: false);
                      await Share.share(
                        tr.shareCityMessage(
                          gamification.currentCurrentLevel,
                          gamification.currentTotalXp,
                        ),
                        subject: tr.focusCityTitle,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.settingsLanguage, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        SegmentedButton<AppLanguage>(
                          segments: [
                            ButtonSegment<AppLanguage>(
                              value: AppLanguage.english,
                              label: Text(tr.settingsLanguageEnglish),
                            ),
                            ButtonSegment<AppLanguage>(
                              value: AppLanguage.cantonese,
                              label: Text(tr.settingsLanguageCantonese),
                            ),
                          ],
                          selected: {tr.language},
                          onSelectionChanged: (Set<AppLanguage> selection) {
                            context.read<LocaleController>().setLanguage(selection.first);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsGroup(
                title: tr.settingsAbout,
                options: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(tr.settingsVersion),
                    trailing: const Text('1.0.0'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsVersionSnack)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: Text(tr.settingsHelp),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.settingsHelpSnack)),
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
                  child: Text(
                    tr.settingsLogout,
                    style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
