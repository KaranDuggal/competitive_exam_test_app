import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  const GoogleAuthProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool get _isMobileGoogleSignInSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<GoogleAuthProfile?> signIn() async {
    if (!_isMobileGoogleSignInSupported) {
      throw UnsupportedError('Google login is coming soon for Linux.');
    }

    await _googleSignIn.initialize(
      serverClientId:
          '853786654754-sd5c03n8f8clqbrtg1oe7db2ivav6cj1.apps.googleusercontent.com',
    );

    final GoogleSignInAccount account = await _googleSignIn.authenticate();

    return GoogleAuthProfile(
      id: account.id,
      name: account.displayName ?? '',
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }

  Future<void> signOut() async {
    if (!_isMobileGoogleSignInSupported) {
      return;
    }
    await _googleSignIn.signOut();
  }
}
