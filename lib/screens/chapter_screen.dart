import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
      appBar: AppBar(
        title: const Text('Chapters'),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.chapters.isEmpty) {
            return const Center(child: Text('No chapters available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizProvider.chapters.length,
            itemBuilder: (context, index) {
              final chapter = quizProvider.chapters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(chapter.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.quiz_outlined),
                  onTap: () => context.push('/quiz-instruction/${chapter.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
