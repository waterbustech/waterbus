// Package imports:
import 'package:auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthServiceImpl({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> initialize() async {}

  @override
  Future<String> signInAnonymously() async {
    final firebaseUserCredential = await _firebaseAuth.signInAnonymously();

    return firebaseUserCredential.user?.uid ?? '';
  }
}
