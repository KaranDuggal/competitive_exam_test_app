class ExamModel {
  final String id;
  final String name;
  final String? image;

  ExamModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '📝',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}