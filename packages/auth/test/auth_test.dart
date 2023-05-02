import 'package:auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_test.mocks.dart';

@GenerateMocks([GoogleSignIn, FirebaseAuth])
void main() {
  final GoogleSignIn googleSignIn = MockGoogleSignIn();
  final FirebaseAuth firebaseAuth = MockFirebaseAuth();
  final AuthService authService = AuthService(
    googleSignIn: googleSignIn,
    firebaseAuth: firebaseAuth,
  );

  group('sign in with google', () {
    test('sign in success', () => null);

    test(
      'sign in failure - firebase response error',
      () => null,
    );

    test('sign in failure - user cancel', () async {
      when(googleSignIn.signIn()).thenAnswer((realInvocation) =>
          throw PlatformException(code: 'sign_in_canceled'));

      final actual = await authService.signInWithGoogle();

      expect(actual, null);
    });
  });

  group('sign in with facebook', () {
    test('sign in success', () => null);

    test(
      'sign in failure - firebase response error',
      () => null,
    );

    test('sign in failure - user cancel', () => null);
  });

  group('sign in with apple', () {
    test('sign in success', () => null);

    test(
      'sign in failure - firebase response error',
      () => null,
    );

    test('sign in failure - user cancel', () => null);
  });
}
