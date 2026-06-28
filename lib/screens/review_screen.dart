import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/app_app_bar.dart';
import '../core/widgets/banner_ad_widget.dart';
import '../providers/quiz_provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Review Answers',
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.questions.length,
            itemBuilder: (context, index) {
              final question = provider.questions[index];
              final selectedIndex = provider.userAnswers[question.id];
              final isCorrect = selectedIndex == question.correctOption;

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCorrect ? Colors.green : Colors.red,
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Question ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(question.text,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 15),
                      ...List.generate(question.options.length, (optIndex) {
                        Color? textColor;
                        if (optIndex == question.correctOption) {
                          textColor = Colors.green;
                        } else if (optIndex == selectedIndex && !isCorrect) {
                          textColor = Colors.red;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                optIndex == question.correctOption
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 16,
                                color: textColor ?? Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  question.options[optIndex],
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: optIndex == question.correctOption
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Explanation:',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            const SizedBox(height: 5),
                            Text(question.explanation),
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
        child: SafeArea(child: BannerAdWidget()),
      ),
    );
  }
}
