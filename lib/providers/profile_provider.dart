import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../models/quiz_history_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileProvider({required ProfileRepository repository})
    : _repository = repository;

  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  List<QuizHistoryModel> _quizHistory = [];

  List<QuizHistoryModel> get quizHistory => _quizHistory;

  bool _isLoadingHistory = false;

  bool get isLoadingHistory => _isLoadingHistory;

  Future<void> loadProfile() async {
    _isLoading = true;

    _error = null;

    notifyListeners();

    try {
      _profile = await _repository.getProfile();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> loadQuizHistory() async {
  try {
    _isLoadingHistory = true;
    notifyListeners();

    _quizHistory = await _repository.getQuizHistory();
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    _isLoadingHistory = false;
    notifyListeners();
  }
}

  Future<void> refresh() async {
    await loadProfile();
  }

  void clear() {
    _profile = null;

    _error = null;

    notifyListeners();
  }
}
