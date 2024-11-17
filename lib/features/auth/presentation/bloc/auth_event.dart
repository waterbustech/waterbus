part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthSignInAnonymously extends AuthEvent {}

class AuthLogOut extends AuthEvent {}
