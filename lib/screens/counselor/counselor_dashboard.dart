import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class CounselorDashboard extends StatefulWidget {
  const CounselorDashboard({super.key});

  @override
  State<CounselorDashboard> createState() => _CounselorDashboardState();
}

class _CounselorDashboardState extends State<CounselorDashboard> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    const Color themeGreen = AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        title: const Text('Counselor Admin Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: themeGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('users')
            .where('role', isEqualTo: 'user')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: themeGreen));
          }
          final users = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Student List (${users.length})',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),

              Expanded(
                child: users.isEmpty
                    ? const Center(child: Text('No registered students found'))
                    : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var userData = users[index].data() as Map<String, dynamic>;
                    String uid = users[index].id;
                    String name = userData['name'] ?? 'Unnamed User';
                    String email = userData['email'] ?? 'No Email';
                    int level = userData['currentLevel'] ?? 0;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: themeGreen.withValues(alpha: .1),
                          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(color: themeGreen)),
                        ),
                        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Level: $level\n$email'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.file_download_outlined, color: themeGreen),
                          onPressed: () => _handleExport(context, uid, name),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('LOGOUT',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();

    if (!context.mounted) return;

    // Redirect to home_screen.dart and clear stack
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> _handleExport(BuildContext context, String uid, String name) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      messenger.showSnackBar(SnackBar(content: Text('Preparing data report for $name...')));
      await _firestoreService.exportUserDataAsTSV(targetUid: uid);
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.redAccent));
    }
  }
}