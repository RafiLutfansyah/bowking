import 'package:google_sign_in/google_sign_in.dart';

class GoogleUserData {
  final String googleId;
  final String email;
  final String name;
  final String? avatarUrl;

  GoogleUserData({
    required this.googleId,
    required this.email,
    required this.name,
    this.avatarUrl,
  });
}

class GoogleSignInDataSource {
  late final GoogleSignIn _googleSignIn;

  GoogleSignInDataSource({String? serverClientId}) {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
        'openid',
      ],
      serverClientId: serverClientId,
    );
  }

  Future<GoogleUserData?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return null;
      }

      return GoogleUserData(
        googleId: account.id,
        email: account.email,
        name: account.displayName ?? '',
        avatarUrl: account.photoUrl,
      );
    } catch (error) {
      throw _handleException(error);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      throw _handleException(error);
    }
  }

  Exception _handleException(dynamic error) {
    if (error.toString().contains('network_error')) {
      return Exception('Network error. Please check your internet connection.');
    } else if (error.toString().contains('sign_in_canceled')) {
      return Exception('Sign in was cancelled.');
    } else if (error.toString().contains('sign_in_failed')) {
      return Exception('Sign in failed. Please try again.');
    } else {
      return Exception('An unexpected error occurred: ${error.toString()}');
    }
  }
}
