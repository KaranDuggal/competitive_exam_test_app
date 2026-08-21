import 'package:exam_jyoti/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../core/widgets/banner_ad_widget.dart';
import '../core/widgets/network_refresh_wrapper.dart';
import '../core/widgets/refreshable_data_view.dart';
import '../providers/quiz_provider.dart';

class QuizSetScreen extends StatefulWidget {
  final String chapterId;
  const QuizSetScreen({super.key, required this.chapterId});

  @override
  State<QuizSetScreen> createState() => _QuizSetScreenState();
}

class _QuizSetScreenState extends State<QuizSetScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<QuizProvider>().loadQuizSets(widget.chapterId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    return Scaffold(
      appBar: const AppAppBar(title: 'Quiz Sets'),
      body: NetworkRefreshWrapper(
        onInternetRestored: () async {
          await context.read<QuizProvider>().loadQuizSets(widget.chapterId);
        },
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            return RefreshableDataView(
              isLoading: quizProvider.isLoading,
              isEmpty: quizProvider.quizSets.isEmpty,
              emptyMessage: 'No quiz sets available',
              onRefresh: () => quizProvider.loadQuizSets(widget.chapterId),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: quizProvider.quizSets.length,
                itemBuilder: (context, index) {
                  final quizSet = quizProvider.quizSets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 80,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          quizSet.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: quizSet.lastAttempt == null
                            ? Text(
                                isLoggedIn ? 'Not attempted yet' : 'Login to the application to see your last attempt score.',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                'Last Score: ${quizSet.lastAttempt!.score}  •  '
                                'Accuracy: ${quizSet.lastAttempt!.accuracy.toStringAsFixed(0)}%',
                              ),
                        trailing: quizSet.lastAttempt == null
                            ? null
                            : CircularPercentIndicator(
                                radius: 26,
                                lineWidth: 6,
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: (quizSet.lastAttempt!.accuracy / 100)
                                    .clamp(0.0, 1.0),
                                progressColor: Colors.green,
                                backgroundColor: Colors.grey.shade300,
                                center: Text(
                                  '${quizSet.lastAttempt!.accuracy.toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        onTap: () {
                          context.read<QuizProvider>().setQuizSet(quizSet.id);
                          context.push('/quiz-instruction/${quizSet.id}');
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const Material(
        elevation: 8,
        child: SafeArea(child: BannerAdWidget()),
      ),
    );
  }
}
