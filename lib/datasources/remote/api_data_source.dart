import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/chapter_model.dart';
import '../../models/exam_model.dart';
import '../../models/question_model.dart';
import '../../models/quiz_set_model.dart';
import '../../models/subject_model.dart';

class ApiDataSource {
  final Dio _dio;

  ApiDataSource({
    required String baseUrl,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            responseType: ResponseType.json,
          ),
        ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<List<ExamModel>> getExams() async {
    final data = await _getList('/exams');

    return data
        .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SubjectModel>> getSubjects(
    String examId,
  ) async {
    final data = await _getList(
      '/subjects',
      queryParameters: {
        'examId': examId,
      },
    );

    return data
        .map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChapterModel>> getChapters(
    String subjectId,
  ) async {
    final data = await _getList(
      '/chapters',
      queryParameters: {
        'subjectId': subjectId,
      },
    );

    return data
        .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuizSetModel>> getQuizSets(
    String chapterId,
  ) async {
    final data = await _getList(
      '/quiz-sets',
      queryParameters: {
        'chapterId': chapterId,
      },
    );

    return data
        .map((e) => QuizSetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuestionModel>> getQuestions(
    String quizSetId,
  ) async {
    final data = await _getList(
      '/questions',
      queryParameters: {
        'quizSetId': quizSetId,
      },
    );

    return data
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<dynamic>> _getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] != true) {
        throw Exception(
          body['message'] ?? 'Something went wrong',
        );
      }

      return body['data'] as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }
}