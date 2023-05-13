part of 'auth_bloc.dart';

abstract class AuthEvent {}

class OnAuthCheckEvent extends AuthEvent {}

class LogInWithSocialEvent extends AuthEvent {
  final AuthPayloadModel authPayload;
  LogInWithSocialEvent({required this.authPayload});
}

class LogOutEvent extends AuthEvent {}
