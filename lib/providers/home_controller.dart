import 'package:flutter/material.dart';
import '../models/exam_model.dart';
import '../repositories/quiz_repository.dart';

class HomeController extends ChangeNotifier {
  final QuizRepository _repository;
  HomeController(this._repository);

  List<ExamModel> _categories = [];
  List<ExamModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchExams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _repository.getExams();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
