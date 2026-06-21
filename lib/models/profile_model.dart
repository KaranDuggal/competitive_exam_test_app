class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  final int totalQuizAttempts;
  final int totalPoints;
  final double averageAccuracy;
  final int currentStreak;
  final int highestStreak;
  final int rank;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.totalQuizAttempts,
    required this.totalPoints,
    required this.averageAccuracy,
    required this.currentStreak,
    required this.highestStreak,
    required this.rank,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'] as String,

      name: json['name'] as String,

      email: json['email'] as String,

      photoUrl: json['photoUrl'] as String?,

      totalQuizAttempts:
          json['totalQuizAttempts'] as int? ?? 0,

      totalPoints:
          json['totalPoints'] as int? ?? 0,

      averageAccuracy:
          (json['averageAccuracy'] as num?)?.toDouble() ??
          0.0,

      currentStreak:
          json['currentStreak'] as int? ?? 0,

      highestStreak:
          json['highestStreak'] as int? ?? 0,

      rank:
          json['rank'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'totalQuizAttempts': totalQuizAttempts,
      'totalPoints': totalPoints,
      'averageAccuracy': averageAccuracy,
      'currentStreak': currentStreak,
      'highestStreak': highestStreak,
      'rank': rank,
    };
  }
}