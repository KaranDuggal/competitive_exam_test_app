import '../models/exam_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/quiz_set_model.dart';
import '../models/question_model.dart';
import '../services/local_json_data_source.dart';
import '../services/api_data_source.dart';

class QuizRepository {
  final LocalJsonDataSource _localDataSource;
  final ApiDataSource _apiDataSource;

  QuizRepository({
    required LocalJsonDataSource localDataSource,
    required ApiDataSource apiDataSource,
  })  : _localDataSource = localDataSource,
        _apiDataSource = apiDataSource;

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
}
