import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizInstructionScreen extends StatelessWidget {
  final String quizSetId;
  const QuizInstructionScreen({super.key, required this.quizSetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Rules',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInstructionItem(Icons.help_outline, 'Read questions carefully'),
            _buildInstructionItem(Icons.timer_outlined, 'Multiple choice options'),
            _buildInstructionItem(Icons.check_circle_outline, 'Submit when finished'),
            _buildInstructionItem(Icons.cancel_outlined, 'No negative marking'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.pushReplacement('/quiz/$quizSetId'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
