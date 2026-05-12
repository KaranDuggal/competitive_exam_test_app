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