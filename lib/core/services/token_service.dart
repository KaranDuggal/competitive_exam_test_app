import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_session_model.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';

  static const String _userKey = 'user_data';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);

    await prefs.remove(_userKey);
  }

  static Future<void> saveUser(UserSessionModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserSessionModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_userKey);

    if (data == null) {
      return null;
    }

    return UserSessionModel.fromJson(jsonDecode(data));
  }
}
