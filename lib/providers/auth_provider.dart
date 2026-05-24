import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/services/auth_service.dart';
import '../core/services/token_service.dart';

import '../models/auth_model.dart';
import '../models/user_session_model.dart';

import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  UserSessionModel? _user;

  UserSessionModel? get user => _user;

  String? _token;

  String? get token => _token;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> loadUserSession() async {
    _token = await TokenService.getToken();

    _user = await TokenService.getUser();

    _isLoggedIn = _token != null && _user != null;

    notifyListeners();
  }

  Future<void> login() async {
    _isLoading = true;

    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _authService.signIn();

      if (googleUser == null) {
        _isLoading = false;

        notifyListeners();

        return;
      }

      final AuthModel response = await _repository.googleLogin(
        googleId: googleUser.id,
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      _token = response.token;

      _user = UserSessionModel(
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      _isLoggedIn = true;

      await TokenService.saveToken(response.token);

      await TokenService.saveUser(_user!);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();

    await TokenService.removeToken();

    _user = null;

    _token = null;

    _isLoggedIn = false;

    notifyListeners();
  }
}
