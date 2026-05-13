import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/router/app_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../providers/quiz_provider.dart';

class QuizInstructionScreen extends StatefulWidget {
  final String quizSetId;

  const QuizInstructionScreen({
    super.key,
    required this.quizSetId,
  });

  @override
  State<QuizInstructionScreen> createState() =>
      _QuizInstructionScreenState();
}

class _QuizInstructionScreenState
    extends State<QuizInstructionScreen> {
  double _minutesPerQuestion = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Instructions',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Rules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            _buildInstructionItem(
              Icons.help_outline,
              'Read questions carefully',
            ),

            _buildInstructionItem(
              Icons.timer_outlined,
              'Select the correct answer',
            ),

            _buildInstructionItem(
              Icons.check_circle_outline,
              'Quiz auto submits when timer ends',
            ),

            _buildInstructionItem(
              Icons.cancel_outlined,
              'No negative marking',
            ),

            const SizedBox(height: 40),

            const Text(
              'Per Question Timer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${_minutesPerQuestion.toInt()} Minute',
              style: const TextStyle(fontSize: 16),
            ),

            Slider(
              value: _minutesPerQuestion,
              min: 1,
              max: 10,
              divisions: 9,
              label:
                  '${_minutesPerQuestion.toInt()} min',
              onChanged: (value) {
                setState(() {
                  _minutesPerQuestion = value;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final provider =
                      context.read<QuizProvider>();

                  await provider.loadQuestions(
                    widget.quizSetId,
                  );

                  provider.startTimer(
                    totalQuestions:
                        provider.questions.length,
                    minutesPerQuestion:
                        _minutesPerQuestion.toInt(),
                    onTimeUp: () {
                      provider.submitQuiz();
                      AppRouter.router.go('/result');
                    },
                  );

                  if (context.mounted) {
                    context.pushReplacement(
                      '/quiz/${widget.quizSetId}',
                    );
                  }
                },
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),

          const SizedBox(width: 15),

          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}