// Package imports:
import 'package:auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';

class AuthServiceImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthServiceImpl({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<AuthPayload?> signInAnonymously() async {
    final firebaseUserCredential = await _firebaseAuth.signInAnonymously();

    return AuthPayload(
      fullName: firebaseUserCredential.user?.displayName ?? 'Waterbus',
      externalId: firebaseUserCredential.user?.uid ?? '',
    );
  }
}
