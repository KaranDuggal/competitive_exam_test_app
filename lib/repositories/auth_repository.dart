import '../datasources/remote/api_data_source.dart';

import '../models/auth_model.dart';

class AuthRepository {
  final ApiDataSource _apiDataSource;

  AuthRepository({required ApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  Future<AuthModel> googleLogin({
    required String googleId,
    required String name,
    required String email,
    String? photoUrl,
  }) {
    return _apiDataSource.googleLogin(
      googleId: googleId,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }
}
