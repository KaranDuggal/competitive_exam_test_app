import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/app_app_bar.dart';
import '../core/widgets/banner_ad_widget.dart';
import '../providers/quiz_provider.dart';

class QuizAttemptReviewScreen extends StatefulWidget {
  final String attemptId;

  const QuizAttemptReviewScreen({
    super.key,
    required this.attemptId,
  });

  @override
  State<QuizAttemptReviewScreen> createState() =>
      _QuizAttemptReviewScreenState();
}

class _QuizAttemptReviewScreenState
    extends State<QuizAttemptReviewScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<QuizProvider>()
          .loadAttemptForReview(widget.attemptId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Review Answers',
      ),

      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {

          // =========================
          // LOADING
          // =========================

          if (provider.isReviewLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =========================
          // ERROR
          // =========================

          if (provider.reviewError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Unable to load quiz review.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: () {
                        provider.loadAttemptForReview(
                          widget.attemptId,
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          // =========================
          // REVIEW DATA
          // =========================

          final answers = provider.reviewAnswers;

          if (answers.isEmpty) {
            return const Center(
              child: Text(
                'No review data available.',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              final answer = answers[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // =========================
                      // QUESTION HEADER
                      // =========================

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                answer.isCorrect
                                    ? Colors.green
                                    : Colors.red,
                            child: Icon(
                              answer.isCorrect
                                  ? Icons.check
                                  : Icons.close,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Question ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // =========================
                      // QUESTION
                      // =========================

                      Text(
                        answer.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // =========================
                      // OPTIONS
                      // =========================

                      ...List.generate(
                        answer.options.length,
                        (optionIndex) {
                          final option =
                              answer.options[optionIndex];

                          final isCorrectAnswer =
                              option == answer.correctAnswer;

                          final isSelectedAnswer =
                              answer.selectedAnswer != null &&
                              option == answer.selectedAnswer;

                          Color? backgroundColor;
                          Color? borderColor;
                          Color? textColor;
                          IconData? icon;

                          // Correct answer
                          if (isCorrectAnswer) {
                            backgroundColor =
                                Colors.green.withOpacity(0.10);
                            borderColor = Colors.green;
                            textColor = Colors.green;
                            icon = Icons.check_circle;
                          }

                          // User selected wrong answer
                          if (isSelectedAnswer &&
                              !answer.isCorrect) {
                            backgroundColor =
                                Colors.red.withOpacity(0.10);
                            borderColor = Colors.red;
                            textColor = Colors.red;
                            icon = Icons.cancel;
                          }

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(8),
                              border: Border.all(
                                color: borderColor ??
                                    Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icon ??
                                      Icons.circle_outlined,
                                  size: 18,
                                  color:
                                      textColor ??
                                          Colors.grey,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: textColor ??
                                          Colors.black87,
                                      fontWeight:
                                          isCorrectAnswer ||
                                                  isSelectedAnswer
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),

                                if (isCorrectAnswer)
                                  const Text(
                                    'Correct',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),

                                if (isSelectedAnswer &&
                                    !answer.isCorrect)
                                  const Text(
                                    'Your answer',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      // =========================
                      // SKIPPED
                      // =========================

                      if (answer.selectedAnswer == null)
                        Container(
                          width: double.infinity,
                          margin:
                              const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                Colors.orange.withOpacity(0.10),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'You skipped this question.',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      // =========================
                      // EXPLANATION
                      // =========================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              Colors.blue.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                Colors.blue.withOpacity(0.20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Explanation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              answer.explanation,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: const Material(
        elevation: 8,
        child: SafeArea(
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}
