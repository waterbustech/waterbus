import 'package:auth/constants/constants.dart';
import 'package:auth/services/auth_service.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';

class AuthServiceImpl extends AuthService {
  late final FirebaseAuth _firebaseAuth;
  late final GoogleSignIn _googleSignIn;

  @override
  Future<void> initialize(Function(AuthPayloadModel payload) callback) async {
    FirebaseAuth.initialize(apiKey, VolatileStore());

    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(
      params: const GoogleSignInParams(
        clientId: kClientIdDesktop,
        // scopes: scopes,
      ),
    );
  }

  @override
  Future<void> signInSilently() async {
    // throw UnimplementedError();
  }

  @override
  Future<AuthPayloadModel?> signInAnonymously() async {
    _firebaseAuth.signOut();

    final user = await _firebaseAuth.signInAnonymously();

    return AuthPayloadModel(
      fullName: user.displayName ?? 'Waterbus',
      googleId: user.id,
      email: user.email,
    );
  }

  @override
  Future<AuthPayloadModel?> signInWithGoogle() async {
    try {
      if (_firebaseAuth.isSignedIn) _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      final creds = await _googleSignIn.signIn();

      if (creds == null) return null;

      await _firebaseAuth.signInWithOAuth(
        'google.com',
        creds.idToken!,
        creds.accessToken,
      );

      if (!_firebaseAuth.isSignedIn) return null;

      final user = await _firebaseAuth.getUser();

      return AuthPayloadModel(
        fullName: user.displayName ?? 'google.user',
        googleId: user.id,
        email: user.email,
      );
    } catch (e) {
      return null;
    }
  }
}
