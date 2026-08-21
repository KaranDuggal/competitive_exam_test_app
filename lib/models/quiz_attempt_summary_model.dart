class QuizAttemptSummaryModel {
  final int score;
  final double accuracy;
  final int pointsEarned;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int timeTaken;
  final DateTime attemptedAt;

  const QuizAttemptSummaryModel({
    required this.score,
    required this.accuracy,
    required this.pointsEarned,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.timeTaken,
    required this.attemptedAt,
  });

  factory QuizAttemptSummaryModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptSummaryModel(
      score: json['score'],
      accuracy: (json['accuracy'] as num).toDouble(),
      pointsEarned: json['pointsEarned'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
      skippedAnswers: json['skippedAnswers'],
      timeTaken: json['timeTaken'],
      attemptedAt: DateTime.parse(json['attemptedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'accuracy': accuracy,
      'pointsEarned': pointsEarned,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'skippedAnswers': skippedAnswers,
      'timeTaken': timeTaken,
      'attemptedAt': attemptedAt.toIso8601String(),
    };
  }
}
