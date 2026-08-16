import 'package:flutter/material.dart';
import '../models/leaderboard_response_model.dart';
import '../models/leaderboard_user_model.dart';
import '../repositories/leaderboard_repository.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardRepository _repository;
  LeaderboardProvider({
    required LeaderboardRepository repository,
  }) : _repository = repository;
  // =========================
  // DATA
  // =========================

  List<LeaderboardUserModel> _leaderboard = [];
  List<LeaderboardUserModel> get leaderboard => _leaderboard;
  int _myRank = 0;
  int get myRank => _myRank;

  // =========================
  // LOADING
  // =========================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // =========================
  // ERROR
  // =========================

  String? _error;
  String? get error => _error;

  // =========================
  // LOAD LEADERBOARD
  // =========================

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final LeaderboardResponseModel response = await _repository.getLeaderboard();
      _leaderboard = response.leaderboard;
      _myRank = response.myRank;
    } catch (e) {
      _leaderboard = [];
      _myRank = 0;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}