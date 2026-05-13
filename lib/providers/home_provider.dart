import 'package:flutter/material.dart';

import '../models/exam_model.dart';
import '../repositories/quiz_repository.dart';

class HomeProvider extends ChangeNotifier {
  final QuizRepository _repository;

  HomeProvider(this._repository);

  List<ExamModel> _exams = [];

  List<ExamModel> get exams => _exams;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> fetchExams() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _exams = await _repository.getExams();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}