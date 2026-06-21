import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../core/widgets/google_login_button.dart';
import '../providers/auth_provider.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authProvider.isLoggedIn && authProvider.user != null) {
            return SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
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
                          const Text(
                            "Quiz 1",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Math • Distance and Time",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Circle
                          Center(
                            child: CircularPercentIndicator(
                              radius: 60,
                              lineWidth: 10,
                              percent: 0.75,
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.green,
                              backgroundColor: Colors.grey.shade300,
                              center: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "75%",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Accuracy"),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: _buildStat(
                                  "Correct",
                                  "15",
                                  Colors.green,
                                ),
                              ),
                              Expanded(
                                child: _buildStat("Wrong", "3", Colors.red),
                              ),
                              Expanded(
                                child: _buildStat(
                                  "Skipped",
                                  "2",
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.stars, color: Colors.amber),
                                  SizedBox(width: 6),
                                  Text(
                                    "87 Points",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  SizedBox(width: 6),
                                  Text("08:00"),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Text(
                            "28 May 2026",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    'Login to Track Your Progress',

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Save your quiz history, track performance, and access your progress anytime.',

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
    );
  }

  static Widget _buildStat(
  String title,
  String value,
  Color color,
) {
  return Column(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),

      const SizedBox(height: 8),

      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    ],
  );
}
}
