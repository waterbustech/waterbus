abstract class AuthService {
  Future<void> initialize();
  Future<String> signInAnonymously();
}
