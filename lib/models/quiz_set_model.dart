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