import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _user != null;

  Future<void> login() async {
    _isLoading = true;

    notifyListeners();

    try {
      _user = await _authService.signIn();
      print(" user: ${_user}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();

    _user = null;

    notifyListeners();
  }
}
