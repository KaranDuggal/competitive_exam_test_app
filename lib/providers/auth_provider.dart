import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/auth_service.dart';
import '../models/auth_model.dart';
import '../repositories/quiz_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final QuizRepository _repository;

  AuthProvider({required QuizRepository repository}) : _repository = repository;

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _user != null;

  String? _token;

  String? get token => _token;

  Future<void> login() async {
    _isLoading = true;

    notifyListeners();

    try {
      final googleUser = await _authService.signIn();

      if (googleUser == null) {
        return;
      }

      _user = googleUser;

      final AuthModel response = await _repository.googleLogin(
        googleId: googleUser.id,
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      _token = response.token;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.token);

      debugPrint('JWT Token: ${response.token}');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');

    _user = null;

    _token = null;

    notifyListeners();
  }
}
