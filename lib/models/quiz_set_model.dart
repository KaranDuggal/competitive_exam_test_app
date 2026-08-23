import 'quiz_attempt_summary_model.dart';

class QuizSetModel {
  final String id;
  final String name;
  final int questionCount;
  final QuizAttemptSummaryModel? lastAttempt;

  const QuizSetModel({
    required this.id,
    required this.name,
    required this.questionCount,
    this.lastAttempt,
  });

  factory QuizSetModel.fromJson(Map<String, dynamic> json) {
    return QuizSetModel(
      id: json['id'],
      name: json['name'],
      questionCount: json['questionCount'] ?? 0,
      lastAttempt: json['lastAttempt'] != null
          ? QuizAttemptSummaryModel.fromJson(json['lastAttempt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questionCount': questionCount,
      'lastAttempt': lastAttempt?.toJson(),
    };
  }
}
