import '../datasources/remote/api_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final ApiDataSource _apiDataSource;

  ProfileRepository({
    required ApiDataSource apiDataSource,
  }) : _apiDataSource = apiDataSource;

  /// =========================
  /// GET PROFILE
  /// =========================
  Future<ProfileModel> getProfile() async {
    return await _apiDataSource.getProfile();
  }
}