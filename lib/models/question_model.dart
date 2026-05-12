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