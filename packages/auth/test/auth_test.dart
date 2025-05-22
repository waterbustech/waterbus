import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  group('sign in with google', () {
    test('sign in success', () => null);

    test(
      'sign in failure - firebase response error',
      () => null,
    );
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
