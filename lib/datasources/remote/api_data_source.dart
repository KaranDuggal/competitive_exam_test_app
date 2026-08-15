import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/token_service.dart';

import '../../models/exam_model.dart';
import '../../models/leaderboard_response_model.dart';
import '../../models/profile_model.dart';
import '../../models/quiz_attempt_request_model.dart';
import '../../models/quiz_attempt_response_model.dart';
import '../../models/subject_model.dart';
import '../../models/chapter_model.dart';
import '../../models/quiz_set_model.dart';
import '../../models/question_model.dart';
import '../../models/auth_model.dart';
import '../../models/quiz_history_model.dart';

class ApiDataSource {
  final Dio _dio;
  final VoidCallback? onUnauthorized;

  ApiDataSource({required String baseUrl, this.onUnauthorized})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await TokenService.removeToken();
            onUnauthorized?.call();
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<List<ExamModel>> getExams() async {
    final response = await _dio.get('/exams');

    final List data = response.data['data'];

    return data.map((json) => ExamModel.fromJson(json)).toList();
  }

  Future<List<SubjectModel>> getSubjects(String examId) async {
    final response = await _dio.get(
      '/subjects',
      queryParameters: {'examId': examId},
    );

    final List data = response.data['data'];

    return data.map((json) => SubjectModel.fromJson(json)).toList();
  }

  Future<List<ChapterModel>> getChapters(String subjectId) async {
    final response = await _dio.get(
      '/chapters',
      queryParameters: {'subjectId': subjectId},
    );

    final List data = response.data['data'];

    return data.map((json) => ChapterModel.fromJson(json)).toList();
  }

  Future<List<QuizSetModel>> getQuizSets(String chapterId) async {
    final response = await _dio.get(
      '/quiz-sets',
      queryParameters: {'chapterId': chapterId},
    );

    final List data = response.data['data'];

    return data.map((json) => QuizSetModel.fromJson(json)).toList();
  }

  Future<List<QuestionModel>> getQuestions(String quizSetId) async {
    final response = await _dio.get(
      '/questions',
      queryParameters: {'quizSetId': quizSetId},
    );

    final List data = response.data['data'];

    return data.map((json) => QuestionModel.fromJson(json)).toList();
  }

  Future<AuthModel> googleLogin({
    required String googleId,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    final response = await _dio.post(
      '/google-login',
      data: {
        'googleId': googleId,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      },
    );

    return AuthModel.fromJson(response.data);
  }

  Future<List<QuizHistoryModel>> getQuizHistory() async {
    final response = await _dio.get('/profile/history');

    final List data = response.data['data'];

    return data.map((e) => QuizHistoryModel.fromJson(e)).toList();
  }

  Future<QuizAttemptResponseModel> submitQuizAttempt(
    QuizAttemptRequestModel request,
  ) async {
    final response = await _dio.post('/quiz-attempts', data: request.toJson());
    return QuizAttemptResponseModel.fromJson(response.data);
  }

  Future<ProfileModel> getProfile() async {
    final response = await _dio.get('/profile/me');

    return ProfileModel.fromJson(response.data['data']);
  }

  Future<LeaderboardResponseModel> getLeaderboard() async {
    final response = await _dio.get('/leaderboard');

    return LeaderboardResponseModel.fromJson(response.data);
  }
}
