// Package imports:
import 'package:auth/constants/constants.dart';
import 'package:auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';

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
  Future<void> initialize(Function(AuthPayload payload) callback) async {
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

        callback(AuthPayload(
          fullName: account.displayName ?? 'google.user',
          externalId: firebaseUserCredential.user?.uid ?? '',
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
  Future<AuthPayload?> signInAnonymously() async {
    final firebaseUserCredential = await _firebaseAuth.signInAnonymously();

    return AuthPayload(
      fullName: firebaseUserCredential.user?.displayName ?? 'Waterbus',
      externalId: firebaseUserCredential.user?.uid ?? '',
    );
  }
}
