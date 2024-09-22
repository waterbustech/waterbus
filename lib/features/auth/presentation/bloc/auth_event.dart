part of 'auth_bloc.dart';

abstract class AuthEvent {}

class OnAuthCheckEvent extends AuthEvent {}

class LogInWithGoogleEvent extends AuthEvent {}

class LogInAnonymously extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
