import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/widgets/app_app_bar.dart';
import '../models/quiz_session_model.dart';
import '../providers/quiz_provider.dart';

class QuizInstructionScreen extends StatefulWidget {
  final QuizSessionData session;
  final String quizSetId;
  const QuizInstructionScreen({
    super.key,
    required this.session,
    required this.quizSetId,
  });

  @override
  State<QuizInstructionScreen> createState() => _QuizInstructionScreenState();
}

class _QuizInstructionScreenState extends State<QuizInstructionScreen> {
  double _minutesPerQuestion = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Instructions'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Rules',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            _buildInstructionItem(Icons.cancel_outlined, 'No negative marking'),
            const SizedBox(height: 40),
            const Text(
              'Per Question Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              label: '${_minutesPerQuestion.toInt()} min',
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
                  final provider = context.read<QuizProvider>();
                  await provider.loadQuestions(widget.session.quizSetId ?? '');
                  context.read<QuizProvider>().setQuizConfiguration(quizDuration: _minutesPerQuestion.toInt() * 60 * provider.questions.length, timePerQuestion: _minutesPerQuestion.toInt());
                  provider.startTimer(
                    totalQuestions: provider.questions.length,
                    minutesPerQuestion:_minutesPerQuestion.toInt(),
                    onTimeUp: () async {
                      await provider.submitQuiz();
                    },
                  );

                  if (context.mounted) {
                    context.pushReplacement(
                      '/quiz/${widget.session.quizSetId}',
                    );
                  }
                },
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
