import '../models/auth_model.dart';
import '../models/exam_model.dart';
import '../models/quiz_attempt_request_model.dart';
import '../models/quiz_attempt_response_model.dart';
import '../models/quiz_attempt_review_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/quiz_set_model.dart';
import '../models/question_model.dart';
import '../datasources/remote/api_data_source.dart';

class QuizRepository {
  final ApiDataSource _apiDataSource;

  QuizRepository({required ApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  Future<List<ExamModel>> getExams() {
    return _apiDataSource.getExams();
  }

  Future<List<SubjectModel>> getSubjects(String examId) {
    return _apiDataSource.getSubjects(examId);
  }

  Future<List<ChapterModel>> getChapters(String subjectId) {
    return _apiDataSource.getChapters(subjectId);
  }

  Future<List<QuizSetModel>> getQuizSets(String chapterId) {
    return _apiDataSource.getQuizSets(chapterId);
  }

  Future<List<QuestionModel>> getQuestions(String quizSetId) {
    return _apiDataSource.getQuestions(quizSetId);
  }

  Future<AuthModel> googleLogin({
    required String googleId,
    required String name,
    required String email,
    String? photoUrl,
  }) {
    return _apiDataSource.googleLogin(
      googleId: googleId,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }

  Future<QuizAttemptResponseModel> submitQuizAttempt(
    QuizAttemptRequestModel request,
  ) {
    return _apiDataSource.submitQuizAttempt(request);
  }

  Future<List<QuizAttemptReviewModel>> getQuizAttempt(String attemptId) {
    return _apiDataSource.getQuizAttempt(attemptId);
  }
}
