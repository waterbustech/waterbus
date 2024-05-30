library auth;

import 'package:auth/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import './widgets/index.dart';

class Auth {
  final AuthService _authService = AuthService();

  Future<void> initialize(Function(AuthPayloadModel payload) callback) =>
      _authService.initialize(callback);
  Future<void> signInSilently() => _authService.signInSilently();
  Future<AuthPayloadModel?> signInWithGoogle() =>
      _authService.signInWithGoogle();
  Future<AuthPayloadModel?> signInWithApple() => _authService.signInWithApple();

  Widget loginRenderWidget() {
    return signInButton();
  }
}
