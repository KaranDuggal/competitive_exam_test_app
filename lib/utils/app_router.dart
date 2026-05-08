import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_view.dart';
import '../screens/subject_screen.dart';
import '../screens/chapter_screen.dart';
import '../screens/quiz_instruction_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';
import '../screens/review_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/subjects/:examId',
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return SubjectScreen(examId: examId);
        },
      ),
      GoRoute(
        path: '/chapters/:subjectId',
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;
          return ChapterScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '/quiz-instruction/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return QuizInstructionScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/quiz/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return QuizScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => const ReviewScreen(),
      ),
    ],
  );
}
