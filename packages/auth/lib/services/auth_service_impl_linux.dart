import 'package:auth/services/auth_service.dart';
import 'package:firedart/auth/firebase_auth.dart';

class AuthServiceImpl extends AuthService {
  late final FirebaseAuth _firebaseAuth;

  @override
  Future<String> signInAnonymously() async {
    _firebaseAuth.signOut();

    final user = await _firebaseAuth.signInAnonymously();

    return user.id;
  }
}
