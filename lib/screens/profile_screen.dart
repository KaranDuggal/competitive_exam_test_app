import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/google_login_button.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!authProvider.isLoggedIn || authProvider.user == null) {
            return Padding(
              padding: const EdgeInsets.all(24),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    CircleAvatar(
                      radius: 45,

                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),

                      child: Icon(
                        Icons.person,
                        size: 50,

                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Login to Access Your Profile',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Sync your account, manage profile details, and keep your exam progress secure across devices.',

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
          }

          final user = authProvider.user!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// PROFILE HEADER
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,

                          backgroundImage: user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : null,

                          child: user.photoUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          user.name,

                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          user.email,

                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// STATS SECTION
                  const Text(
                    'Your Progress',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Quizzes',
                          value: '0',
                          icon: Icons.quiz,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: _buildStatCard(
                          title: 'Points',
                          value: '0',
                          icon: Icons.stars,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Accuracy',
                          value: '0%',
                          icon: Icons.analytics,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: _buildStatCard(
                          title: 'Rank',
                          value: '#0',
                          icon: Icons.leaderboard,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// SETTINGS
                  const Text(
                    'Settings',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      children: [
                        /// DARK MODE
                        SwitchListTile(
                          title: const Text('Dark Mode'),

                          secondary: const Icon(Icons.dark_mode),

                          value: themeProvider.themeMode == ThemeMode.dark,

                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                        ),

                        const Divider(height: 1),

                        /// NOTIFICATION
                        ListTile(
                          leading: const Icon(Icons.notifications),

                          title: const Text('Notifications'),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () {},
                        ),

                        const Divider(height: 1),

                        /// ABOUT
                        ListTile(
                          leading: const Icon(Icons.info),

                          title: const Text('About App'),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () async {
                        await authProvider.logout();
                      },

                      icon: const Icon(Icons.logout),

                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Icon(icon, size: 32),

            const SizedBox(height: 12),

            Text(
              value,

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(title, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
