import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../providers/quiz_provider.dart';

class ChapterScreen extends StatefulWidget {
  final String subjectId;
  const ChapterScreen({super.key, required this.subjectId});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<QuizProvider>().loadChapters(widget.subjectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Chapters',
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading && quizProvider.chapters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget content;
          if (quizProvider.chapters.isEmpty) {
            content = const Center(child: Text('No chapters available'));
          } else {
            content = ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: quizProvider.chapters.length,
              itemBuilder: (context, index) {
                final chapter = quizProvider.chapters[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(chapter.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/quiz-sets/${chapter.id}'),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => quizProvider.loadChapters(widget.subjectId),
            child: quizProvider.chapters.isEmpty
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
