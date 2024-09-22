// Package imports:
import 'package:auth/constants/constants.dart';
import 'package:auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';

class AuthServiceImpl extends AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthServiceImpl({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = GoogleSignIn(
          scopes: scopes,
          clientId: kIsWeb ? kClientIdWeb : null,
        ),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> initialize(Function(AuthPayloadModel payload) callback) async {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;

      if (kIsWeb && isAuthorized) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential firebaseUserCredential =
            await _firebaseAuth.signInWithCredential(googleCredential);

        if (firebaseUserCredential.user == null) {
          return;
        }

        callback(AuthPayloadModel(
          fullName: account.displayName ?? 'google.user',
          googleId: firebaseUserCredential.user?.uid ?? '',
          email: firebaseUserCredential.user?.email,
        ));
      }
    });
  }

  @override
  Future<void> signInSilently() async {
    if (!kIsWeb) return;

    _googleSignIn.signInSilently();
  }

  @override
  Future<AuthPayloadModel?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
      );
      final UserCredential firebaseUserCredential =
          await _firebaseAuth.signInWithCredential(googleCredential);

      if (firebaseUserCredential.user == null) {
        return null;
      }

      return AuthPayloadModel(
        fullName: googleUser.displayName ?? 'google.user',
        googleId: firebaseUserCredential.user?.uid ?? '',
        email: firebaseUserCredential.user?.email,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthPayloadModel?> signInAnonymously() async {
    final firebaseUserCredential = await _firebaseAuth.signInAnonymously();

    return AuthPayloadModel(
      fullName: firebaseUserCredential.user?.displayName ?? 'Waterbus',
      appleId: firebaseUserCredential.user?.uid ?? '',
      email: firebaseUserCredential.user?.email,
    );
  }
}
