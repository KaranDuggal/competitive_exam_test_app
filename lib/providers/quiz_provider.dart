import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import '../repositories/quiz_repository.dart';

class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider({required QuizRepository repository}) : _repository = repository;

  List<SubjectModel> _subjects = [];
  List<ChapterModel> _chapters = [];
  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, int> _userAnswers = {}; // questionId -> selectedIndex
  ResultModel? _lastResult;

  List<SubjectModel> get subjects => _subjects;
  List<ChapterModel> get chapters => _chapters;
  List<QuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<String, int> get userAnswers => _userAnswers;
  ResultModel? get lastResult => _lastResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSubjects(String examId) async {
    _isLoading = true;
    notifyListeners();
    _subjects = await _repository.getSubjects(examId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadChapters(String subjectId) async {
    _isLoading = true;
    notifyListeners();
    _chapters = await _repository.getChapters(subjectId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuestions(String chapterId) async {
    _isLoading = true;
    notifyListeners();
    _questions = await _repository.getQuestions(chapterId);
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _isLoading = false;
    notifyListeners();
  }

  void selectAnswer(String questionId, int selectedIndex) {
    _userAnswers[questionId] = selectedIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void submitQuiz() {
    int correct = 0;
    for (var question in _questions) {
      if (_userAnswers[question.id] == question.correctAnswerIndex) {
        correct++;
      }
    }
    
    _lastResult = ResultModel(
      totalQuestions: _questions.length,
      correctAnswers: correct,
      wrongAnswers: _questions.length - correct,
      percentage: (_questions.isEmpty) ? 0 : (correct / _questions.length) * 100,
    );
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _lastResult = null;
    notifyListeners();
  }
}
