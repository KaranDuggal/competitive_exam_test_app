import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/widgets/app_app_bar.dart';
import '../models/quiz_session_model.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  final QuizSessionData session;
  final String quizSetId;
  const QuizScreen({super.key, required this.session, required this.quizSetId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizProvider _quizProvider;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quizProvider = Provider.of<QuizProvider>(context, listen: false);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _quizProvider.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Quiz',
        actions: [
          Consumer<QuizProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      provider.formattedTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${provider.currentQuestionIndex + 1}/${provider.questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value:
                      (provider.currentQuestionIndex + 1) /
                      provider.questions.length,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 30),
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(question.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        provider.selectAnswer(question.id, index);
                      },
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
                              backgroundColor: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.grey,
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
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
                    if (provider.currentQuestionIndex <
                        provider.questions.length - 1)
                      ElevatedButton(
                        onPressed: provider.nextQuestion,
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () async {
                          await provider.submitQuiz(
                            quizSetId: widget.session.quizSetId ?? '',
                            subjectId: widget.session.subjectId ?? '',
                            chapterId: widget.session.chapterId ?? '',
                            timePerQuestion:
                                widget.session.timePerQuestion ?? 1,
                            quizDuration: widget.session.quizDuration ?? 10,
                          );
                          context.go('/result');
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
