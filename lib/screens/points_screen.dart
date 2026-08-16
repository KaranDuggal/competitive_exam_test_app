import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../core/widgets/banner_ad_widget.dart';
import '../core/widgets/google_login_button.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();

  static Widget buildStat(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();

      if (authProvider.isLoggedIn) {
        context.read<ProfileProvider>().loadQuizHistory();
      }
    });
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return "${hours.toString().padLeft(2, "0")}h "
          "${minutes.toString().padLeft(2, "0")}m";
    }

    return "${minutes.toString().padLeft(2, "0")}m "
        "${remainingSeconds.toString().padLeft(2, "0")}s";
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ProfileProvider>(
        builder: (context, authProvider, profileProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authProvider.isLoggedIn && authProvider.user != null) {
            if (profileProvider.isLoadingHistory) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profileProvider.quizHistory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "No quiz attempts found.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        profileProvider.loadQuizHistory();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await profileProvider.loadQuizHistory();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: profileProvider.quizHistory.length,
                  itemBuilder: (context, index) {
                    final attempt = profileProvider.quizHistory[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Quiz Name
                            Text(
                              attempt.quizName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${attempt.subjectName} • ${attempt.chapterName}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Accuracy Circle
                            Center(
                              child: CircularPercentIndicator(
                                radius: 60,
                                lineWidth: 10,
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: attempt.accuracy / 100,
                                progressColor: Colors.green,
                                backgroundColor: Colors.grey.shade300,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${attempt.accuracy.toInt()}%",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text("Accuracy"),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// Correct / Wrong / Skipped
                            Row(
                              children: [
                                Expanded(
                                  child: PointsScreen.buildStat(
                                    "Correct",
                                    attempt.correctAnswers.toString(),
                                    Colors.green,
                                  ),
                                ),
                                Expanded(
                                  child: PointsScreen.buildStat(
                                    "Wrong",
                                    attempt.wrongAnswers.toString(),
                                    Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: PointsScreen.buildStat(
                                    "Skipped",
                                    attempt.skippedAnswers.toString(),
                                    Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 32),

                            /// Bottom Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stars,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${attempt.pointsEarned} Points",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.timer),
                                    const SizedBox(width: 6),
                                    Text(formatDuration(attempt.timeTaken)),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              formatDate(attempt.attemptedAt),
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_outlined, size: 80),

                  const SizedBox(height: 24),

                  const Text(
                    'Login to Track Your Progress',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Save your quiz history, points, accuracy and performance analytics.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  GoogleLoginButton(
                    onPressed: () async {
                      await authProvider.login();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Material(
        elevation: 8,
        child: SafeArea(child: BannerAdWidget()),
      ),
    );
  }
}
