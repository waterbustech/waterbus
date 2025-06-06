import 'package:auth/constants/constants.dart';
import 'package:auth/services/auth_service.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';

class AuthServiceImpl extends AuthService {
  late final FirebaseAuth _firebaseAuth;

  @override
  Future<void> initialize() async {
    FirebaseAuth.initialize(apiKey, VolatileStore());
    _firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future<String> signInAnonymously() async {
    _firebaseAuth.signOut();

    final user = await _firebaseAuth.signInAnonymously();

    return user.id;
  }
}
