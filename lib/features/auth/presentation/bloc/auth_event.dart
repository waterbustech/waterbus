part of 'auth_bloc.dart';

abstract class AuthEvent {}

class OnAuthCheckEvent extends AuthEvent {}

class LogInWithGoogleEvent extends AuthEvent {}

class LogInWithFacebookEvent extends AuthEvent {}

class LogInWithAppleEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
