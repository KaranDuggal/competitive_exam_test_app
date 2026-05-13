import 'dart:async';

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

  // =========================
  // SUBJECTS
  // =========================

  List<SubjectModel> _subjects = [];

  List<SubjectModel> get subjects => _subjects;

  // =========================
  // CHAPTERS
  // =========================

  List<ChapterModel> _chapters = [];

  List<ChapterModel> get chapters => _chapters;

  // =========================
  // QUIZ SETS
  // =========================

  List<QuizSetModel> _quizSets = [];

  List<QuizSetModel> get quizSets => _quizSets;

  // =========================
  // QUESTIONS
  // =========================

  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  // =========================
  // CURRENT QUESTION
  // =========================

  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  // =========================
  // USER ANSWERS
  // =========================

  Map<String, int> _userAnswers = {};

  Map<String, int> get userAnswers => _userAnswers;

  // =========================
  // RESULT
  // =========================

  ResultModel? _lastResult;

  ResultModel? get lastResult => _lastResult;

  // =========================
  // LOADING & ERROR
  // =========================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  // =========================
  // TIMER
  // =========================

  Timer? _timer;

  int _remainingSeconds = 0;

  int get remainingSeconds => _remainingSeconds;

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (_remainingSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void startTimer({
    required int totalQuestions,
    required int minutesPerQuestion,
    required VoidCallback onTimeUp,
  }) {
    stopTimer();

    _remainingSeconds =
        totalQuestions * minutesPerQuestion * 60;

    notifyListeners();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          notifyListeners();
        } else {
          stopTimer();

          onTimeUp();
        }
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();

    _timer = null;
  }

  // =========================
  // LOAD SUBJECTS
  // =========================

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

  // =========================
  // LOAD CHAPTERS
  // =========================

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

  // =========================
  // LOAD QUIZ SETS
  // =========================

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

  // =========================
  // LOAD QUESTIONS
  // =========================

  Future<void> loadQuestions(String quizSetId) async {
    _isLoading = true;

    _error = null;

    notifyListeners();

    try {
      _questions = await _repository.getQuestions(
        quizSetId,
      );

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

  // =========================
  // SELECT ANSWER
  // =========================

  void selectAnswer(
    String questionId,
    int selectedIndex,
  ) {
    _userAnswers[questionId] = selectedIndex;

    notifyListeners();
  }

  // =========================
  // NEXT QUESTION
  // =========================

  void nextQuestion() {
    if (_currentQuestionIndex <
        _questions.length - 1) {
      _currentQuestionIndex++;

      notifyListeners();
    }
  }

  // =========================
  // PREVIOUS QUESTION
  // =========================

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;

      notifyListeners();
    }
  }

  // =========================
  // SUBMIT QUIZ
  // =========================

  void submitQuiz() {
    stopTimer();

    int correctAnswers = 0;

    for (final question in _questions) {
      if (_userAnswers[question.id] ==
          question.correctOption) {
        correctAnswers++;
      }
    }

    _lastResult = ResultModel(
      totalQuestions: _questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers:
          _questions.length - correctAnswers,
      percentage: _questions.isEmpty
          ? 0
          : (correctAnswers / _questions.length) *
              100,
    );

    notifyListeners();
  }

  // =========================
  // RESET QUIZ
  // =========================

  void resetQuiz() {
    stopTimer();

    _currentQuestionIndex = 0;

    _userAnswers = {};

    _lastResult = null;

    _remainingSeconds = 0;

    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();

    super.dispose();
  }
}