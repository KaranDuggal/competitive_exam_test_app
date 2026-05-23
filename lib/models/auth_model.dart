class AuthModel {
  final bool success;
  final String message;
  final String token;

  AuthModel({
    required this.success,
    required this.message,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
    );
  }
}