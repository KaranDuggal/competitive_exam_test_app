import 'leaderboard_user_model.dart';

class LeaderboardResponseModel {
  final List<LeaderboardUserModel> leaderboard;
  final int myRank;

  const LeaderboardResponseModel({
    required this.leaderboard,
    required this.myRank,
  });

  factory LeaderboardResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return LeaderboardResponseModel(
      leaderboard: (data['leaderboard'] as List)
          .map((e) => LeaderboardUserModel.fromJson(e))
          .toList(),
      myRank: data['myRank'],
    );
  }
}