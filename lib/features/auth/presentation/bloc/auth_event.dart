part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedInWithNewLobby extends AuthEvent {
  final String code;
  final String password;
  final String? fullname;

  AuthLoggedInWithNewLobby({
    required this.code,
    this.fullname,
    required this.password,
  });
}

class AuthLoggedOut extends AuthEvent {}
