class QuizSessionData {
  final String? examId;
  final String? subjectId;
  final String? chapterId;
  final String? quizSetId;
  final int timePerQuestion;
  final int? quizDuration;
  final int? questionCount;

  const QuizSessionData({
    this.examId,
    this.subjectId,
    this.chapterId,
    this.quizSetId,
    this.timePerQuestion = 2,
    this.quizDuration,
    this.questionCount,
  });

  QuizSessionData copyWith({
    String? examId,
    String? subjectId,
    String? chapterId,
    String? quizSetId,
    int? timePerQuestion,
    int? quizDuration,
    int? questionCount,
  }) {
    return QuizSessionData(
      examId: examId ?? this.examId,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      quizSetId: quizSetId ?? this.quizSetId,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      quizDuration: quizDuration ?? this.quizDuration,
      questionCount: questionCount ?? this.questionCount,
    );
  }
}