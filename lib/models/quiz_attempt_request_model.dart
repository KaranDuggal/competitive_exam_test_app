class QuizAnswerRequest {
  final String questionId;
  final String? selectedAnswer;
  final bool isCorrect;

  QuizAnswerRequest({
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
    };
  }
}

class QuizAttemptRequestModel {
  final String quizSetId;
  final String subjectId;
  final String chapterId;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int timePerQuestion;
  final int quizDuration;
  final int timeTaken;
  final int correctMarks;
  final int negativeMarks;
  final List<QuizAnswerRequest> answers;

  QuizAttemptRequestModel({
    required this.quizSetId,
    required this.subjectId,
    required this.chapterId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.timePerQuestion,
    required this.quizDuration,
    required this.timeTaken,
    required this.correctMarks,
    required this.negativeMarks,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizSetId': quizSetId,
      'subjectId': subjectId,
      'chapterId': chapterId,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'skippedAnswers': skippedAnswers,
      'timePerQuestion': timePerQuestion,
      'quizDuration': quizDuration,
      'timeTaken': timeTaken,
      'correctMarks': correctMarks,
      'negativeMarks': negativeMarks,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}