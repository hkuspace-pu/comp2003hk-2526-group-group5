import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FamilyLeaderboard extends StatelessWidget {
  const FamilyLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    const Color themeGreen = AppColors.primaryGreen;
    const Color goldColor = AppColors.xpGold;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        title: const Text('Family Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: themeGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // 1. First, find which group the current user belongs to
        future: FirebaseFirestore.instance.collection('users').doc(currentUid).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
          final String? groupId = userData?['groupId'];

          if (groupId == null || groupId.isEmpty) {
            return _buildNoGroupView(context);
          }

          // 2. Then, stream all users who share that same groupId
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('groupId', isEqualTo: groupId)
                .orderBy('totalXp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // If you see PERMISSION_DENIED here, check your Firebase Rules
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final members = snapshot.data!.docs;

              return Column(
                children: [
                  _buildHeaderCard(members.length, themeGreen),
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemBuilder: (context, index) {
                        var data = members[index].data() as Map<String, dynamic>;
                        bool isMe = members[index].id == currentUid;
                        return _buildLeaderboardTile(
                          rank: index + 1,
                          name: data['name'] ?? 'Anonymous Member',
                          xp: data['totalXp'] ?? 0,
                          level: data['currentLevel'] ?? 0,
                          isMe: isMe,
                          themeGreen: themeGreen,
                          goldColor: goldColor,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildLeaderboardTile({
    required int rank,
    required String name,
    required int xp,
    required int level,
    required bool isMe,
    required Color themeGreen,
    required Color goldColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isMe ? themeGreen.withValues(alpha: .1) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isMe ? Border.all(color: themeGreen, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: SizedBox(
          width: 40,
          child: _getRankIcon(rank, goldColor) ??
              Center(
                child: Text('#$rank',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
        ),
        title: Text(
          isMe ? "$name (Me)" : name,
          style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal, fontSize: 16),
        ),
        subtitle: Text('Focus City Level: Lv.$level'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$xp XP', style: TextStyle(color: themeGreen, fontWeight: FontWeight.bold, fontSize: 18)),
            const Text('Total XP', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget? _getRankIcon(int rank, Color gold) {
    if (rank == 1) return Icon(Icons.emoji_events, color: gold, size: 30);
    if (rank == 2) return const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 28);
    if (rank == 3) return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 26);
    return null;
  }

  Widget _buildHeaderCard(int count, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: .7)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Family Group', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 4),
              Text('Competition makes progress fun!', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text('$count', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildNoGroupView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_add, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text('Not in a family group yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            child: const Text('Go to Settings to Join'),
          )
        ],
      ),
    );
  }
}