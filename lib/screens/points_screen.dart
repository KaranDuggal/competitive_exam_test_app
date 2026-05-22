import 'package:flutter/material.dart';

import '../core/widgets/google_login_button.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

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

              const Text(
                'Login to Track Your Progress',

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}