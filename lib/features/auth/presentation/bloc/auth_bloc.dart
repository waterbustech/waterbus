// Package imports:
import 'package:auth/auth.dart';
import 'package:auth/models/auth_payload_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/usecases/check_auth.dart';
import 'package:waterbus/features/auth/domain/usecases/login_with_social.dart';
import 'package:waterbus/features/auth/domain/usecases/logout.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth _checkAuth;
  final LoginWithSocial _loginWithSocial;
  final LogOut _logOut;

  User? user;

  AuthBloc(
    this._checkAuth,
    this._loginWithSocial,
    this._logOut,
  ) : super(AuthInitial()) {
    Auth().initialize((payload) async {
      final Either<Failure, User> loginSucceed = await _loginWithSocial.call(
        AuthParams(payloadModel: payload),
      );

      // Pop loading
      AppNavigator.pop();

      loginSucceed.fold((l) {}, (r) {
        user = r;
      });

      add(OnAuthCheckEvent());
    });

    on<AuthEvent>((event, emit) async {
      if (event is OnAuthCheckEvent) {
        final Either<Failure, User> hasLogined = await _checkAuth.call(null);
        FlutterNativeSplash.remove();

        hasLogined.fold(
          (l) => emit(_authFailure),
          (r) {
            user = r;
            return emit(_authSuccess);
          },
        );
      }

      if (event is LogInWithGoogleEvent ||
          event is LogInWithFacebookEvent ||
          event is LogInWithAppleEvent) {
        await _handleLogin(event);

        if (user != null) emit(_authSuccess);
      }

      if (event is LogOutEvent) {
        await _handleLogOut();

        if (user == null) {
          emit(_authFailure);
        }
      }
    });
  }

  // MARK: state
  AuthSuccess get _authSuccess {
    AppBloc.instance.bootstrap();
    return AuthSuccess();
  }

  AuthFailure get _authFailure {
    Auth().signInSilently();

    return AuthFailure();
  }

  // MARK: Private methods
  Future<void> _handleLogin(AuthEvent event) async {
    displayLoadingLayer();

    late final AuthPayloadModel? payload;

    switch (event) {
      case LogInWithGoogleEvent():
        payload = await Auth().signInWithGoogle();
        break;
      case LogInWithFacebookEvent():
        payload = await Auth().signInWithFacebook();
        break;
      case LogInWithAppleEvent():
        payload = await Auth().signInWithApple();
        break;
      default:
        payload = null;
        break;
    }

    if (payload == null) {
      // Pop loading
      AppNavigator.pop();
      return;
    }

    final Either<Failure, User> loginSucceed = await _loginWithSocial.call(
      AuthParams(payloadModel: payload),
    );

    // Pop loading
    AppNavigator.pop();

    loginSucceed.fold((l) {}, (r) {
      user = r;
    });
  }

  Future<void> _handleLogOut() async {
    final Either<Failure, bool> logOutSucceed = await _logOut.call(NoParams());

    if (logOutSucceed.isRight()) {
      user = null;
      AppBloc.userBloc.add(CleanProfileEvent());
      AppBloc.meetingListBloc.add(CleanAllRecentJoinedEvent());
    }
  }
}
