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

  factory QuizAttemptSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuizAttemptSummaryModel(
      score: (json['score'] as num?)?.toInt() ?? 0,

      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,

      pointsEarned:
          (json['pointsEarned'] as num?)?.toInt() ?? 0,

      correctAnswers:
          (json['correctAnswers'] as num?)?.toInt() ?? 0,

      wrongAnswers:
          (json['wrongAnswers'] as num?)?.toInt() ?? 0,

      skippedAnswers:
          (json['skippedAnswers'] as num?)?.toInt() ?? 0,

      timeTaken:
          (json['timeTaken'] as num?)?.toInt() ?? 0,

      attemptedAt:
          DateTime.parse(json['attemptedAt'] as String),
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