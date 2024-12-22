part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthGoogleLogined extends AuthEvent {}

class AuthAnonymouslyLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}
