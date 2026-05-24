class UserSessionModel {
  final String name;
  final String email;
  final String? photoUrl;

  UserSessionModel({required this.name, required this.email, this.photoUrl});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }
}
