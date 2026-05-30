class QuizSessionData {
  final String? examId;
  final String? subjectId;
  final String? chapterId;
  final String? quizSetId;
  final int timePerQuestion;
  final int? quizDuration;

  const QuizSessionData({
    this.examId,
    this.subjectId,
    this.chapterId,
    this.quizSetId,
    this.timePerQuestion = 2,
    this.quizDuration,
  });

  QuizSessionData copyWith({
    String? examId,
    String? subjectId,
    String? chapterId,
    String? quizSetId,
    int? timePerQuestion,
    int? quizDuration,
  }) {
    return QuizSessionData(
      examId: examId ?? this.examId,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      quizSetId: quizSetId ?? this.quizSetId,
      timePerQuestion:
          timePerQuestion ?? this.timePerQuestion,
      quizDuration:
          quizDuration ?? this.quizDuration,
    );
  }
}