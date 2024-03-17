library auth;

import 'package:auth/models/auth_payload_model.dart';
import 'package:auth/services/auth_service.dart';

class Auth {
  final AuthService _authService = AuthService();

  Future<void> initialize(Function(AuthPayloadModel payload) callback) =>
      _authService.initialize(callback);
  Future<void> signInSilently() => _authService.signInSilently();
  Future<AuthPayloadModel?> signInWithGoogle() =>
      _authService.signInWithGoogle();
  Future<AuthPayloadModel?> signInWithFacebook() =>
      _authService.signInWithFacebook();
  Future<AuthPayloadModel?> signInWithApple() => _authService.signInWithApple();
}
