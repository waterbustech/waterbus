import 'package:waterbus_sdk/types/index.dart';

abstract class AuthService {
  Future<void> initialize(Function(AuthPayload payload) callback);
  Future<void> signInSilently();
  Future<AuthPayload?> signInAnonymously();
}
