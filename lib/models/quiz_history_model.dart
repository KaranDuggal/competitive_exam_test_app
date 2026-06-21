class QuizHistoryModel {
  final String id;
  final String quizName;
  final String subjectName;
  final String chapterName;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int score;
  final double accuracy;
  final int pointsEarned;
  final int timeTaken;
  final DateTime attemptedAt;

  QuizHistoryModel({
    required this.id,
    required this.quizName,
    required this.subjectName,
    required this.chapterName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.score,
    required this.accuracy,
    required this.pointsEarned,
    required this.timeTaken,
    required this.attemptedAt,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      id: json["id"],
      quizName: json["quizName"],
      subjectName: json["subjectName"],
      chapterName: json["chapterName"],
      totalQuestions: json["totalQuestions"],
      correctAnswers: json["correctAnswers"],
      wrongAnswers: json["wrongAnswers"],
      skippedAnswers: json["skippedAnswers"],
      score: json["score"],
      accuracy: (json["accuracy"] as num).toDouble(),
      pointsEarned: json["pointsEarned"],
      timeTaken: json["timeTaken"],
      attemptedAt: DateTime.parse(json["attemptedAt"]),
    );
  }
}