import 'package:flutter/material.dart';

import '../models/chapter_model.dart';
import '../models/question_model.dart';
import '../models/quiz_set_model.dart';
import '../models/result_model.dart';
import '../models/subject_model.dart';
import '../repositories/quiz_repository.dart';

class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider({
    required QuizRepository repository,
  }) : _repository = repository;

  List<SubjectModel> _subjects = [];

  List<SubjectModel> get subjects => _subjects;

  List<ChapterModel> _chapters = [];

  List<ChapterModel> get chapters => _chapters;

  List<QuizSetModel> _quizSets = [];

  List<QuizSetModel> get quizSets => _quizSets;

  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  Map<String, int> _userAnswers = {};

  Map<String, int> get userAnswers => _userAnswers;

  ResultModel? _lastResult;

  ResultModel? get lastResult => _lastResult;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> loadSubjects(String examId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _subjects = await _repository.getSubjects(examId);
    } catch (e) {
      _subjects = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChapters(String subjectId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _chapters = await _repository.getChapters(subjectId);
    } catch (e) {
      _chapters = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuizSets(String chapterId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _quizSets = await _repository.getQuizSets(chapterId);
    } catch (e) {
      _quizSets = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuestions(String quizSetId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _questions = await _repository.getQuestions(quizSetId);

      _currentQuestionIndex = 0;

      _userAnswers = {};
    } catch (e) {
      _questions = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(
    String questionId,
    int selectedIndex,
  ) {
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
    int correctAnswers = 0;

    for (final question in _questions) {
      if (_userAnswers[question.id] == question.correctOption) {
        correctAnswers++;
      }
    }

    _lastResult = ResultModel(
      totalQuestions: _questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: _questions.length - correctAnswers,
      percentage: _questions.isEmpty
          ? 0
          : (correctAnswers / _questions.length) * 100,
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