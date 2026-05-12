class UserAnswerModel {
  final String questionId;
  final int selectedAnswerIndex;

  UserAnswerModel({
    required this.questionId,
    required this.selectedAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswerIndex': selectedAnswerIndex,
    };
  }
}