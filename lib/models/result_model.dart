class ResultModel {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;

  ResultModel({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
      percentage: json['percentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'percentage': percentage,
    };
  }
}