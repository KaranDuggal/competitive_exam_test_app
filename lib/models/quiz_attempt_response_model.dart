class QuizAttemptResponseModel {
  final bool success;
  final String message;
  final QuizResultData data;

  QuizAttemptResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory QuizAttemptResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuizAttemptResponseModel(
      success: json['success'],
      message: json['message'],
      data: QuizResultData.fromJson(json['data']),
    );
  }
}

class QuizResultData {
  final String attemptId;
  final int score;
  final double accuracy;
  final int pointsEarned;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int expectedTime;
  final int timeTaken;

  QuizResultData({
    required this.attemptId,
    required this.score,
    required this.accuracy,
    required this.pointsEarned,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.expectedTime,
    required this.timeTaken,
  });

  factory QuizResultData.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuizResultData(
      attemptId: json['attemptId'],
      score: json['score'],
      accuracy: (json['accuracy'] as num).toDouble(),
      pointsEarned: json['pointsEarned'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
      skippedAnswers: json['skippedAnswers'],
      expectedTime: json['expectedTime'],
      timeTaken: json['timeTaken'],
    );
  }
}