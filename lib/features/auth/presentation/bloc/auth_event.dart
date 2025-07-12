part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedInAndJoinedRoom extends AuthEvent {
  final String code;
  final String password;
  final String? fullname;

  AuthLoggedInAndJoinedRoom({
    required this.code,
    this.fullname,
    required this.password,
  });
}

class AuthLoggedOut extends AuthEvent {}
