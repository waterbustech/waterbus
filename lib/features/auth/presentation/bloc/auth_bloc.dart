// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is OnAuthCheckEvent) {}

      if (event is LogInWithGoogleEvent) {}

      if (event is LogInWithFacebookEvent) {}

      if (event is LogInWithAppleEvent) {}

      if (event is LogOutEvent) {}
    });
  }
}
