class ExamModel {
  final String id;
  final String name;
  final String icon;

  ExamModel({
    required this.id,
    required this.name,
    this.icon = '📝',
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? '📝',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

class SubjectModel {
  final String id;
  final String name;
  final String icon;

  SubjectModel({
    required this.id,
    required this.name,
    this.icon = '📚',
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? '📚',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

class ChapterModel {
  final String id;
  final String name;

  ChapterModel({
    required this.id,
    required this.name,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class QuizSetModel {
  final String id;
  final String name;

  QuizSetModel({
    required this.id,
    required this.name,
  });

  factory QuizSetModel.fromJson(Map<String, dynamic> json) {
    return QuizSetModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class QuestionModel {
  final String id;
  final String text;
  final List<String> options;
  final int correctOption;
  final String explanation;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctOption: json['correctOption'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOption': correctOption,
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
