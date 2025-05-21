import 'package:auth/services/auth_service.dart';
import 'package:auth/services/index.dart';

class Auth {
  final AuthService _authService = getInstance;

  Future<String> signInAnonymously() => _authService.signInAnonymously();
}
