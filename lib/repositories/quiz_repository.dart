import '../models/quiz_models.dart';
import '../services/local_json_data_source.dart';

class QuizRepository {
  final LocalJsonDataSource _localDataSource;
  // Future: final ApiDataSource _apiDataSource;

  QuizRepository({required LocalJsonDataSource localDataSource})
      : _localDataSource = localDataSource;

  Future<List<ExamModel>> getExams() {
    return _localDataSource.getExams();
  }

  Future<List<SubjectModel>> getSubjects(String examId) {
    return _localDataSource.getSubjects(examId);
  }

  Future<List<ChapterModel>> getChapters(String subjectId) {
    return _localDataSource.getChapters(subjectId);
  }

  Future<List<QuestionModel>> getQuestions(String chapterId) {
    return _localDataSource.getQuestions(chapterId);
  }
}
