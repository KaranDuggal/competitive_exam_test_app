import 'package:flutter/material.dart';
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
            final user = authProvider.user!;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    CircleAvatar(
                      radius: 45,

                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,

                      child: user.photoUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      user.name,

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      user.email,

                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.08),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            'Coming Soon',

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Points, leaderboard, achievements, and quiz analytics will appear here.',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await authProvider.logout();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },

                      icon: const Icon(Icons.logout),

                      label: const Text('Logout'),
                    ),
                  ],
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
}
