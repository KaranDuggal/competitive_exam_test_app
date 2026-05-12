import 'package:dio/dio.dart';
import '../models/quiz_models.dart';

class ApiDataSource {
  final Dio _dio;

  ApiDataSource({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        )) {
    // Optional: Add interceptors for logging or header management
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<List<ExamModel>> getExams() async {
    try {
      final response = await _dio.get('/exams');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final List data = body['data'] as List;
          return data.map((e) => ExamModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load exams');
        }
      } else {
        throw Exception('Failed to load exams from API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<SubjectModel>> getSubjects(String examId) async {
    try {
      final response = await _dio.get('/subjects', queryParameters: {'examId': examId});
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final List data = body['data'] as List;
          return data.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load subjects');
        }
      } else {
        throw Exception('Failed to load subjects from API: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<ChapterModel>> getChapters(String subjectId) async {
    try {
      final response = await _dio.get('/chapters', queryParameters: {'subjectId': subjectId});
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final List data = body['data'] as List;
          return data.map((e) => ChapterModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load chapters');
        }
      } else {
        throw Exception('Failed to load chapters from API: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<QuizSetModel>> getQuizSets(String chapterId) async {
    try {
      final response = await _dio.get('/quiz-sets', queryParameters: {'chapterId': chapterId});
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final List data = body['data'] as List;
          return data.map((e) => QuizSetModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load quiz sets');
        }
      } else {
        throw Exception('Failed to load quiz sets from API: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<QuestionModel>> getQuestions(String quizSetId) async {
    try {
      final response = await _dio.get('/questions', queryParameters: {'quizSetId': quizSetId});
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final List data = body['data'] as List;
          return data.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load questions');
        }
      } else {
        throw Exception('Failed to load questions from API: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
