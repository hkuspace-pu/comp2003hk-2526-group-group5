import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../core/constants/app_colors.dart';
import '../../providers/gamification_provider.dart';
import '../../services/firestore_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // Re-authentication Dialog Logic
  // This verifies the user's password before allowing sensitive data export.
  Future<bool> _authenticateUser(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    bool isVerified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog( // Use a separate dialogContext
        title: const Text('Confirm Identity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to authorize the data export.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () async {
              try {
                auth.AuthCredential credential = auth.EmailAuthProvider.credential(
                  email: currentUser!.email!,
                  password: passwordController.text,
                );

                // Wait for Firebase
                await currentUser.reauthenticateWithCredential(credential);

                // CHECK THE GAP: Ensure the dialog is still there before popping
                if (!dialogContext.mounted) return;

                isVerified = true;
                Navigator.pop(dialogContext);
              } catch (e) {
                // Check mounted status before showing SnackBar
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Authentication failed: Incorrect password.')),
                );
              }
            },
            child: const Text('Verify', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return isVerified;
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = AppColors.primaryGreen;
    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

    return Consumer<GamificationProvider>(
      builder: (context, gamificationData, _) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Account',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            //  Profile Avatar Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: appBarColor.withValues(alpha: .1),
                        backgroundImage: const AssetImage('images/profile.png'),
                      ),
                      const SizedBox(height: 16),
                      Text(firebaseUser?.displayName ?? 'Focus User',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(firebaseUser?.email ?? 'No email connected',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(gamificationData.timeSpentString,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Statistics Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatColumn(
                              icon: Icons.star,
                              value: gamificationData.currentTotalXp.toString(),
                              label: 'XP',
                              color: Colors.orange),
                          _StatColumn(
                              icon: Icons.leaderboard,
                              value: gamificationData.currentCurrentLevel == 6
                                  ? "MAX"
                                  : gamificationData.currentCurrentLevel.toString(),
                              label: 'Level',
                              color: Colors.blueAccent),
                          _StatColumn(
                              icon: Icons.category,
                              value: gamificationData.currentPlacedItems.length.toString(),
                              label: 'Items',
                              color: Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Settings Group: Account Management
            _buildSettingsGroup(
              context,
              title: 'Account Management',
              children: [
                _buildMenuTile(Icons.person_outline, 'Edit Profile', onTap: () {}),
                _buildMenuTile(Icons.history, 'Focus History', onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),

            // Settings Group: Data Export (TSV) with Security Check
            _buildSettingsGroup(
              context,
              title: 'Data Export',
              children: [
                _buildMenuTile(
                  Icons.file_download_outlined,
                  'Export Your Data (TSV)',
                  onTap: () async {
                    // Trigger the security check
                    final bool isAuthorized = await _authenticateUser(context);

                    // If password was correct, proceed with export
                    if (isAuthorized) {
                      if (!context.mounted) return;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(const SnackBar(content: Text('Preparing your TSV report...')));
                      try {
                        await _firestoreService.exportUserDataAsTSV();
                        messenger.showSnackBar(const SnackBar(content: Text('Export successful!')));
                      } catch (e) {
                        messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // UI Helper
  Widget _buildSettingsGroup(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // UI Helper: Builds a single tile in the settings menu
  Widget _buildMenuTile(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// Specialized UI component for Stat Columns
class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatColumn({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
      ],
    );
  }
}