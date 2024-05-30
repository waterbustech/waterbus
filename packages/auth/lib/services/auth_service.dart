// Dart imports:
import 'dart:convert';
import 'dart:math';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';

const List<String> scopes = <String>[
  'email',
];

class AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = GoogleSignIn(
          scopes: scopes,
          clientId: kIsWeb
              ? '727554668212-292n8fha44s1tmj0s3d0fqv0qv75bm9r.apps.googleusercontent.com'
              : null,
        ),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

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

  Future<void> signInSilently() async {
    if (!kIsWeb) return;

    _googleSignIn.signInSilently();
  }

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

  Future<AuthPayloadModel?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential firebaseUserCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (firebaseUserCredential.user == null) {
        return null;
      }

      return AuthPayloadModel(
        fullName: appleCredential.givenName ?? 'apple.user',
        appleId: firebaseUserCredential.user?.uid ?? '',
        email: firebaseUserCredential.user?.email,
      );
    } catch (e) {
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
