import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  final String quizSetId;
  const QuizScreen({super.key, required this.quizSetId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<QuizProvider>().loadQuestions(widget.quizSetId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Quiz',
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Consumer<QuizProvider>(
                builder: (context, provider, _) {
                  return Text(
                    '${provider.currentQuestionIndex + 1}/${provider.questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.questions.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final question = provider.questions[provider.currentQuestionIndex];
          final selectedIndex = provider.userAnswers[question.id];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: provider.questions.isEmpty ? 0 : (provider.currentQuestionIndex + 1) / provider.questions.length,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 30),
                Text(
                  question.text,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                ...List.generate(question.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => provider.selectAnswer(question.id, index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: selectedIndex == index ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: selectedIndex == index
                              ? Colors.blue.withOpacity(0.1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: selectedIndex == index ? Colors.blue : Colors.grey,
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(child: Text(question.options[index])),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (provider.currentQuestionIndex > 0)
                      TextButton(
                        onPressed: provider.previousQuestion,
                        child: const Text('Previous'),
                      )
                    else
                      const SizedBox(),
                    if (provider.currentQuestionIndex < provider.questions.length - 1)
                      ElevatedButton(
                        onPressed: provider.nextQuestion,
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          provider.submitQuiz();
                          context.pushReplacement('/result');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit Quiz'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
