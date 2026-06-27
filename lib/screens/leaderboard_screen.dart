import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/google_login_button.dart';
import '../providers/auth_provider.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.isLoggedIn) {
        context.read<LeaderboardProvider>().loadLeaderboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, LeaderboardProvider>(
        builder: (context, authProvider, leaderboardProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!authProvider.isLoggedIn) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login to View Leaderboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    GoogleLoginButton(
                      onPressed: () async {
                        await authProvider.login();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (leaderboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final leaderboard = leaderboardProvider.leaderboard;
          final myRank = leaderboardProvider.myRank;

          if (leaderboard.isEmpty) {
            return const Center(child: Text("No leaderboard available"));
          }

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Leaderboard",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// TOP 3
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: leaderboard.length > 1
                            ? _buildTopUser(
                                rank: leaderboard[1].rank,
                                name: leaderboard[1].name,
                                points: leaderboard[1].totalPoints,
                                photoUrl: leaderboard[1].photoUrl,
                                height: 120,
                                color: Colors.blueGrey,
                              )
                            : const SizedBox(),
                      ),

                      Expanded(
                        child: leaderboard.isNotEmpty
                            ? _buildTopUser(
                                rank: leaderboard[0].rank,
                                name: leaderboard[0].name,
                                points: leaderboard[0].totalPoints,
                                photoUrl: leaderboard[0].photoUrl,
                                height: 170,
                                color: Colors.orange,
                              )
                            : const SizedBox(),
                      ),

                      Expanded(
                        child: leaderboard.length > 2
                            ? _buildTopUser(
                                rank: leaderboard[2].rank,
                                name: leaderboard[2].name,
                                points: leaderboard[2].totalPoints,
                                photoUrl: leaderboard[2].photoUrl,
                                height: 100,
                                color: const Color(0xFFCD7F32),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "Your Rank",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "#$myRank",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: leaderboard.length > 3
                        ? leaderboard.length - 3
                        : 0,
                    itemBuilder: (context, index) {
                      final user = leaderboard[index + 3];

                      final hasValidPhoto =
                          user.photoUrl != null &&
                          user.photoUrl!.isNotEmpty &&
                          user.photoUrl!.startsWith("http");

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text(
                                  "#${user.rank}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              CircleAvatar(
                                radius: 20,
                                child: ClipOval(
                                  child: hasValidPhoto
                                      ? Image.network(
                                          user.photoUrl!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(Icons.person);
                                          },
                                        )
                                      : const Icon(Icons.person),
                                ),
                              ),
                            ],
                          ),

                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          subtitle: Text(
                            "${user.totalQuizAttempts} quizzes • ${user.averageAccuracy.toStringAsFixed(1)}%",
                          ),

                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${user.totalPoints}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Text("pts"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildTopUser({
  required int rank,
  required String name,
  required int points,
  required String? photoUrl,
  required double height,
  required Color color,
}) {
  return Column(
    children: [
      if (rank == 1)
        const Icon(Icons.workspace_premium, color: Colors.orange, size: 34),
      if (rank == 1) const SizedBox(height: 6),
      CircleAvatar(
        radius: rank == 1 ? 36 : 30,
        backgroundColor: color,
        backgroundImage: photoUrl != null && photoUrl.isNotEmpty
            ? NetworkImage(photoUrl)
            : null,
        child: (photoUrl == null || photoUrl.isEmpty)
            ? Icon(
                rank == 1
                    ? Icons.emoji_events
                    : rank == 2
                    ? Icons.workspace_premium
                    : Icons.military_tech,
                color: Colors.white,
                size: 22,
              )
            : null,
      ),

      const SizedBox(height: 10),

      Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      Text("$points pts", style: TextStyle(color: Colors.blueGrey.shade600)),

      const SizedBox(height: 12),

      Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(.85), color.withOpacity(.45)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    ],
  );
}
