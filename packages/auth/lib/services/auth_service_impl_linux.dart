import 'package:auth/services/auth_service.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:waterbus_sdk/types/index.dart';

class AuthServiceImpl extends AuthService {
  late final FirebaseAuth _firebaseAuth;

  @override
  Future<AuthPayload?> signInAnonymously() async {
    _firebaseAuth.signOut();

    final user = await _firebaseAuth.signInAnonymously();

    return AuthPayload(
      fullName: user.displayName ?? 'Waterbus',
      externalId: user.id,
    );
  }
}
