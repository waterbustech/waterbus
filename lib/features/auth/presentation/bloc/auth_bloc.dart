// Package imports:
import 'package:auth/models/auth_payload_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/usecases/check_auth.dart';
import 'package:waterbus/features/auth/domain/usecases/login_with_social.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth _checkAuth;
  final LoginWithSocial _loginWithSocial;

  User? user;

  AuthBloc(
    this._checkAuth,
    this._loginWithSocial,
  ) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is OnAuthCheckEvent) {
        final Either<Failure, User> hasLogined = await _checkAuth.call(null);
        hasLogined.fold(
          (l) => emit(AuthFailure()),
          (r) {
            user = r;
            return emit(AuthSuccess());
          },
        );
      }

      if (event is LogInWithSocialEvent) {
        showDialogLoading();

        await _handleLogin(event);

        // Pop loading after request completed
        AppNavigator.pop();

        if (user != null) emit(AuthSuccess());
      }

      if (event is LogOutEvent) {}
    });
  }

  // MARK: Private methods
  Future<void> _handleLogin(LogInWithSocialEvent event) async {
    final Either<Failure, User> loginSucceed = await _loginWithSocial
        .call(AuthParams(payloadModel: event.authPayload));

    loginSucceed.fold((l) {}, (r) {
      user = r;
    });
  }
}
