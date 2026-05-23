import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final GoogleSignIn _googleSignIn =
      GoogleSignIn.instance;

  Future<GoogleSignInAccount?> signIn() async {

    await _googleSignIn.initialize(
      serverClientId:
          '853786654754-sd5c03n8f8clqbrtg1oe7db2ivav6cj1.apps.googleusercontent.com',
    );

    final GoogleSignInAccount account =
        await _googleSignIn.authenticate();

    return account;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}