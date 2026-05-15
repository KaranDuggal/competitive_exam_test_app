import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
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
    Future.microtask(() =>
        context.read<QuizProvider>().loadQuizSets(widget.chapterId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Quiz Sets',
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading && quizProvider.quizSets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget content;
          if (quizProvider.quizSets.isEmpty) {
            content = const Center(child: Text('No quiz sets available'));
          } else {
            content = ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: quizProvider.quizSets.length,
              itemBuilder: (context, index) {
                final quizSet = quizProvider.quizSets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(quizSet.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.quiz_outlined),
                    onTap: () =>
                        context.push('/quiz-instruction/${quizSet.id}'),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => quizProvider.loadQuizSets(widget.chapterId),
            child: quizProvider.quizSets.isEmpty
                ? Stack(
                    children: [
                      ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                      content,
                    ],
                  )
                : content,
          );
        },
      ),
    );
  }
}
