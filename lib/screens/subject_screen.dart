import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../core/widgets/network_refresh_wrapper.dart';
import '../core/widgets/refreshable_data_view.dart';
import '../providers/quiz_provider.dart';

class SubjectScreen extends StatefulWidget {
  final String examId;
  const SubjectScreen({super.key, required this.examId});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<QuizProvider>().loadSubjects(widget.examId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Subjects',
      ),
      body: NetworkRefreshWrapper(
        onInternetRestored: () async {
          await context.read<QuizProvider>().loadSubjects(widget.examId);
        },
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            return RefreshableDataView(
              isLoading: quizProvider.isLoading,
              isEmpty: quizProvider.subjects.isEmpty,
              emptyMessage: 'No subjects available',
              onRefresh: () => quizProvider.loadSubjects(widget.examId),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: quizProvider.subjects.length,
                itemBuilder: (context, index) {
                  final subject = quizProvider.subjects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Text(subject.icon,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(subject.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/chapters/${subject.id}'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
