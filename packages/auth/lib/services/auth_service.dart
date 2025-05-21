import 'package:waterbus_sdk/types/index.dart';

abstract class AuthService {
  Future<AuthPayload?> signInAnonymously();
}
