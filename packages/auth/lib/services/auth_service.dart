import 'package:waterbus_sdk/types/index.dart';

abstract class AuthService {
  Future<void> initialize(Function(AuthPayloadModel payload) callback);
  Future<void> signInSilently();
  Future<AuthPayloadModel?> signInWithGoogle();
  Future<AuthPayloadModel?> signInAnonymously();
}
