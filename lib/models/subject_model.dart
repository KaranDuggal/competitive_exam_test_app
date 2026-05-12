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