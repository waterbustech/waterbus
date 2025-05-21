import 'package:auth/services/auth_service.dart';
import 'package:auth/services/index.dart';
import 'package:flutter/widgets.dart';
import 'package:waterbus_sdk/types/index.dart';

class Auth {
  final AuthService _authService = getInstance;

  Future<AuthPayload?> signInAnonymously() => _authService.signInAnonymously();

  Widget loginRenderWidget() {
    return const SizedBox();
  }
}
