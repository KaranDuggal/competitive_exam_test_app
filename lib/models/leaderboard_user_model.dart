class LeaderboardUserModel {
  final int rank;
  final String id;
  final String name;
  final String? photoUrl;
  final int totalPoints;
  final int totalQuizAttempts;
  final double averageAccuracy;
  final int currentStreak;

  const LeaderboardUserModel({
    required this.rank,
    required this.id,
    required this.name,
    this.photoUrl,
    required this.totalPoints,
    required this.totalQuizAttempts,
    required this.averageAccuracy,
    required this.currentStreak,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      rank: json['rank'],
      id: json['id'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      totalPoints: json['totalPoints'],
      totalQuizAttempts: json['totalQuizAttempts'],
      averageAccuracy:
          (json['averageAccuracy'] as num).toDouble(),
      currentStreak: json['currentStreak'],
    );
  }
}