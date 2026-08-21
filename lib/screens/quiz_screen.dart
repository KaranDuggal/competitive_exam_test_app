import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/services/interstitial_ad_service.dart';
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
  late InterstitialAdService _interstitialAdService;
  final ScrollController _scrollController = ScrollController();
  bool _timerStarted = false;
  final ScrollController _questionNumberController = ScrollController();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  void _scrollToCurrentQuestion(int index) {
    const double itemWidth = 48.0;

    final targetOffset = index * itemWidth;

    final maxOffset = _questionNumberController.position.maxScrollExtent;

    final offset = targetOffset.clamp(0.0, maxOffset);

    _questionNumberController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _interstitialAdService = Provider.of<InterstitialAdService>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();

    _quizProvider.stopTimer();

    _scrollController.dispose();
    _questionNumberController.dispose();
    _timerStarted = false;
    super.dispose();
  }

  void _goToNextQuestion(QuizProvider provider) {
    _scrollController.jumpTo(0);
    final question = provider.questions[provider.currentQuestionIndex];

    final isAnswered = provider.userAnswers.containsKey(question.id);

    if (!isAnswered) {
      provider.markQuestionAsSkipped(question.id);
    }

    provider.nextQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentQuestion(provider.currentQuestionIndex);
    });
  }

  void _goToPreviousQuestion(QuizProvider provider) {
    _scrollController.jumpTo(0);

    provider.previousQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentQuestion(provider.currentQuestionIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Quiz",
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
                      "${provider.currentQuestionIndex + 1}/${provider.questions.length}",
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
            return const Center(child: Text("No questions available"));
          }

          if (!_timerStarted) {
            _timerStarted = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.startTimer(
                totalQuestions: provider.questions.length,

                minutesPerQuestion: widget.session.timePerQuestion,

                onTimeUp: () async {
                  if (provider.isSubmittingQuiz) {
                    return;
                  }

                  await provider.submitQuiz();

                  if (!context.mounted) {
                    return;
                  }

                  _interstitialAdService.show(
                    onFinished: () {
                      if (context.mounted) {
                        context.go("/result");
                      }
                    },
                  );
                },
              );
            });
          }

          final question = provider.questions[provider.currentQuestionIndex];

          final selectedIndex = provider.userAnswers[question.id];

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Question Number Navigation
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              controller: _questionNumberController,
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.questions.length,
                              itemBuilder: (context, index) {
                                final question = provider.questions[index];

                                final isCurrent =
                                    provider.currentQuestionIndex == index;

                                final isAnswered = provider.userAnswers
                                    .containsKey(question.id);

                                final isSkipped = provider.skippedQuestions
                                    .contains(question.id);

                                return GestureDetector(
                                  onTap: provider.isSubmittingQuiz
                                      ? null
                                      : () {
                                          provider.goToQuestion(index);

                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                _scrollToCurrentQuestion(index);
                                              });
                                        },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCurrent
                                          ? Colors.blue
                                          : isAnswered
                                          ? Colors.green
                                          : isSkipped
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isCurrent || isAnswered || isSkipped
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Quiz Progress
                          LinearProgressIndicator(
                            value:
                                (provider.currentQuestionIndex + 1) /
                                provider.questions.length,

                            borderRadius: BorderRadius.circular(10),
                          ),

                          const SizedBox(height: 24),

                          /// Question
                          Text(
                            question.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// Options
                          ...List.generate(question.options.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),

                                onTap: provider.isSubmittingQuiz
                                    ? null
                                    : () {
                                        provider.selectAnswer(
                                          question.id,
                                          index,
                                        );
                                      },

                                child: Container(
                                  width: double.infinity,

                                  padding: const EdgeInsets.all(16),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),

                                    border: Border.all(
                                      color: selectedIndex == index
                                          ? Colors.blue
                                          : Colors.grey.shade400,

                                      width: selectedIndex == index ? 2 : 1,
                                    ),

                                    color: selectedIndex == index
                                        ? Colors.blue.withOpacity(0.08)
                                        : null,
                                  ),

                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      CircleAvatar(
                                        radius: 14,

                                        backgroundColor: selectedIndex == index
                                            ? Colors.blue
                                            : Colors.grey,

                                        child: Text(
                                          String.fromCharCode(65 + index),

                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      Expanded(
                                        child: Text(
                                          question.options[index],

                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Bottom Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (provider.currentQuestionIndex > 0)
                        TextButton(
                          onPressed: () {
                            _goToPreviousQuestion(provider);
                          },
                          child: const Text("Previous"),
                        )
                      else
                        const SizedBox(),

                      if (provider.currentQuestionIndex <
                          provider.questions.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            _goToNextQuestion(provider);
                          },
                          child: const Text("Next"),
                        )
                      else
                        ElevatedButton(
                          onPressed: provider.isSubmittingQuiz
                              ? null
                              : () async {
                                  _scrollController.jumpTo(0);
                                  await provider.submitQuiz();
                                  if (!context.mounted) {
                                    return;
                                  }
                                  _interstitialAdService.show(
                                    onFinished: () {
                                      if (context.mounted) {
                                        context.go("/result");
                                      }
                                    },
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: provider.isSubmittingQuiz
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Submit Quiz"),
                        ),
                    ],
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
