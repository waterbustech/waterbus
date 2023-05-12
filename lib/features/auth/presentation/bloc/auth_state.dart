part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthFailure extends AuthState {}

class AuthSuccess extends AuthState {}
