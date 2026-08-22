import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../core/widgets/banner_ad_widget.dart';
import '../providers/quiz_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.read<QuizProvider>().lastResult;

    if (result == null) {
      return const Scaffold(body: Center(child: Text('No result found')));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.pushReplacement(
          '/quiz-sets/${context.read<QuizProvider>().session.chapterId}',
        );
      },
      child: Scaffold(
        appBar: const AppAppBar(title: 'Result'),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                '${result.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                result.percentage >= 50 ? 'Well Done!' : 'Keep Practicing!',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40),
              _buildResultRow(
                'Total Questions',
                result.totalQuestions.toString(),
              ),
              _buildResultRow(
                'Correct Answers',
                result.correctAnswers.toString(),
                Colors.green,
              ),
              _buildResultRow(
                'Wrong Answers',
                result.wrongAnswers.toString(),
                Colors.red,
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Home'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/review'),
                      child: const Text('Review'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Material(
          elevation: 8,
          child: SafeArea(child: BannerAdWidget()),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
