library auth;

import 'package:auth/models/auth_payload_model.dart';
import 'package:auth/services/auth_service.dart';

class Auth {
  final AuthService _authService = AuthService();

  Future<AuthPayloadModel?> signInWithGoogle() =>
      _authService.signInWithGoogle();
  Future<AuthPayloadModel?> signInWithFacebook() =>
      _authService.signInWithFacebook();
  Future<AuthPayloadModel?> signInWithApple() => _authService.signInWithApple();
}
