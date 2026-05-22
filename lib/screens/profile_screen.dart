import 'package:flutter/material.dart';

import '../core/widgets/google_login_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              CircleAvatar(
                radius: 45,

                backgroundColor:
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.1),

                child: Icon(
                  Icons.person,
                  size: 50,

                  color:
                      Theme.of(context)
                          .colorScheme
                          .primary,
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
                onPressed: () {

                  // TODO:
                  // Implement Google Login

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}