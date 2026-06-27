import '../datasources/remote/api_data_source.dart';
import '../models/leaderboard_response_model.dart';

class LeaderboardRepository {
  final ApiDataSource _api;

  LeaderboardRepository({
    required ApiDataSource api,
  }) : _api = api;

  Future<LeaderboardResponseModel> getLeaderboard() {
    return _api.getLeaderboard();
  }
}