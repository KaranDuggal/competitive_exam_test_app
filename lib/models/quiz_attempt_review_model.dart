class QuizAttemptReviewModel {
  final String question;
  final List<String> options;
  final String? selectedAnswer;
  final String? correctAnswer;
  final bool isCorrect;
  final String explanation;
  QuizAttemptReviewModel({
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
  });
  factory QuizAttemptReviewModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptReviewModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      selectedAnswer: json['selectedAnswer'],
      correctAnswer: json['correctAnswer'],
      isCorrect: json['isCorrect'] ?? false,
      explanation: json['explanation'] ?? '',
    );
  }
}
