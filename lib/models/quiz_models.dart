class ExamModel {
  final String id;
  final String title;
  final String icon;

  ExamModel({
    required this.id,
    required this.title,
    required this.icon,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }
}

class SubjectModel {
  final String id;
  final String examId;
  final String title;
  final String icon;

  SubjectModel({
    required this.id,
    required this.examId,
    required this.title,
    required this.icon,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      examId: json['examId'],
      title: json['title'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'title': title,
      'icon': icon,
    };
  }
}

class ChapterModel {
  final String id;
  final String subjectId;
  final String title;

  ChapterModel({
    required this.id,
    required this.subjectId,
    required this.title,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'],
      subjectId: json['subjectId'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
    };
  }
}

class QuestionModel {
  final String id;
  final String chapterId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuestionModel({
    required this.id,
    required this.chapterId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      chapterId: json['chapterId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }
}

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
