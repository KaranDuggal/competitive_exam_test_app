import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/quiz_set_model.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';
import '../repositories/quiz_repository.dart';

class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider({required QuizRepository repository}) : _repository = repository;

  List<SubjectModel> _subjects = [];
  List<ChapterModel> _chapters = [];
  List<QuizSetModel> _quizSets = [];
  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, int> _userAnswers = {}; // questionId -> selectedIndex
  ResultModel? _lastResult;

  List<SubjectModel> get subjects => _subjects;
  List<ChapterModel> get chapters => _chapters;
  List<QuizSetModel> get quizSets => _quizSets;
  List<QuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<String, int> get userAnswers => _userAnswers;
  ResultModel? get lastResult => _lastResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSubjects(String examId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await _repository.getSubjects(examId);
    } catch (e) {
      _subjects = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadChapters(String subjectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _chapters = await _repository.getChapters(subjectId);
    } catch (e) {
      _chapters = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuizSets(String chapterId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _quizSets = await _repository.getQuizSets(chapterId);
    } catch (e) {
      _quizSets = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuestions(String quizSetId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _questions = await _repository.getQuestions(quizSetId);
      _currentQuestionIndex = 0;
      _userAnswers = {};
    } catch (e) {
      _questions = [];
    }
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
      if (_userAnswers[question.id] == question.correctOption) {
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
