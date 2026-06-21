import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chapter_model.dart';
import '../models/question_model.dart';
import '../models/quiz_attempt_request_model.dart';
import '../models/quiz_attempt_response_model.dart';
import '../models/quiz_set_model.dart';
import '../models/result_model.dart';
import '../models/subject_model.dart';
import '../models/quiz_session_model.dart';
import '../repositories/quiz_repository.dart';
import '../core/services/token_service.dart';

class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider({required QuizRepository repository}) : _repository = repository;

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

  bool _isSubmittingQuiz = false;

  bool get isSubmittingQuiz => _isSubmittingQuiz;

  QuizAttemptResponseModel? _quizAttemptResponse;

  QuizAttemptResponseModel? get quizAttemptResponse => _quizAttemptResponse;

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

  DateTime? _quizStartTime;

  int _remainingSeconds = 0;

  int get remainingSeconds => _remainingSeconds;

  // =========================
  // QUIZ SESSION
  // =========================

  QuizSessionData _session = const QuizSessionData();

  QuizSessionData get session => _session;

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');

    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void startTimer({
  required int totalQuestions,
  required int minutesPerQuestion,
  required VoidCallback onTimeUp,
}) {
  stopTimer();

  _quizStartTime = DateTime.now();

  _remainingSeconds = totalQuestions * minutesPerQuestion * 60;

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

  // =========================
  // SELECT ANSWER
  // =========================

  void selectAnswer(String questionId, int selectedIndex) {
    _userAnswers[questionId] = selectedIndex;

    notifyListeners();
  }

  // =========================
  // NEXT QUESTION
  // =========================

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
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

  Future<void> submitQuiz() async {
    try {
      _isSubmittingQuiz = true;
      stopTimer();
      notifyListeners();
      int correctAnswers = 0;
      final answers = <QuizAnswerRequest>[];
      for (final question in _questions) {
        final selectedIndex = _userAnswers[question.id];
        final isCorrect = selectedIndex == question.correctOption;
        if (isCorrect) {
          correctAnswers++;
        }
        answers.add(
          QuizAnswerRequest(
            questionId: question.id,
            selectedAnswer: selectedIndex != null
                ? question.options[selectedIndex]
                : null,
            isCorrect: isCorrect,
          ),
        );
      }
      final skippedAnswers = _questions.length - _userAnswers.length;
      final wrongAnswers = _questions.length - correctAnswers - skippedAnswers;
      final timeTaken = DateTime.now().difference(_quizStartTime!).inSeconds;
      final request = QuizAttemptRequestModel(
        quizSetId: session.quizSetId!,
        subjectId: session.subjectId!,
        chapterId: session.chapterId!,
        totalQuestions: _questions.length,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        skippedAnswers: skippedAnswers,
        timePerQuestion: session.timePerQuestion,
        quizDuration: session.quizDuration!,
        timeTaken: timeTaken,
        correctMarks: 4,
        negativeMarks: 1,
        answers: answers,
      );
      final token = await TokenService.getToken();
      if (token == null) {
        _lastResult = ResultModel(
          totalQuestions: _questions.length,
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          percentage: _questions.isEmpty
              ? 0
              : (correctAnswers / _questions.length) * 100,
        );

        _isSubmittingQuiz = false;
        notifyListeners();

        return;
      }
      _quizAttemptResponse = await _repository.submitQuizAttempt(request);
      final data = _quizAttemptResponse!.data;
      _lastResult = ResultModel(
        totalQuestions: data.totalQuestions,
        correctAnswers: data.correctAnswers,
        wrongAnswers: data.wrongAnswers,
        percentage: data.accuracy,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isSubmittingQuiz = false;

      notifyListeners();
    }
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

  void setExam(String examId) {
    _session = _session.copyWith(examId: examId);

    notifyListeners();
  }

  void setSubject(String subjectId) {
    _session = _session.copyWith(subjectId: subjectId);

    notifyListeners();
  }

  void setChapter(String chapterId) {
    _session = _session.copyWith(chapterId: chapterId);

    notifyListeners();
  }

  void setQuizSet(String quizSetId) {
    _session = _session.copyWith(quizSetId: quizSetId);

    notifyListeners();
  }

  void setQuizConfiguration({
    required int timePerQuestion,
    required int quizDuration,
  }) {
    _session = _session.copyWith(
      timePerQuestion: timePerQuestion,
      quizDuration: quizDuration,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();

    super.dispose();
  }
}
// =========================
// QUIZ SESSION
// =========================

QuizSessionData _session = const QuizSessionData();

QuizSessionData get session => _session;
