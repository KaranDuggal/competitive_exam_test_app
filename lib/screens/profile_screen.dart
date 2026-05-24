import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/google_login_button.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                      radius: 50,

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
                      width: double.infinity,

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
                            'Profile Features Coming Soon',

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Account settings, achievements, exam analytics, badges, and synced progress will appear here.',

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
                        await authProvider.logout();
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

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        },
      ),
    );
  }
}
