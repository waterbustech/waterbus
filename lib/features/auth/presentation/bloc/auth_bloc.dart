import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/data/datasources/user_local_datasource.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLocalDataSource _userLocal;
  final Auth _auth = Auth();

  User? _user;

  AuthBloc(this._userLocal) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthStarted) {
        await _onAuthCheck(emit);
      }

      if (event is AuthGoogleLogined || event is AuthAnonymouslyLoggedIn) {
        await _handleLogin(event);

        if (_user != null) emit(_authSuccess);
      }

      if (event is AuthLoggedOut) {
        await _handleLogOut();

        if (_user == null) {
          emit(_authFailure);
        }
      }
    });
  }

  Future<void> _onAuthCheck(Emitter<AuthState> emit) async {
    final User? user = _userLocal.getUser();

    if (user != null) {
      _user = user;
      await WaterbusSdk.instance.renewToken();
    }

    FlutterNativeSplash.remove();

    emit(_user == null ? _authFailure : _authSuccess);
  }

  // MARK: state
  AuthSucceeded get _authSuccess {
    AppBloc.instance.bootstrap();

    return AuthSucceeded();
  }

  AuthFailure get _authFailure {
    return AuthFailure();
  }

  // MARK: Private methods
  Future<void> _handleLogin(AuthEvent event) async {
    displayLoadingLayer();

    late final AuthPayload? payload;

    switch (event) {
      case AuthAnonymouslyLoggedIn():
        payload = await _auth.signInAnonymously();
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
    final Result<User> result = await WaterbusSdk.instance.createToken(payload);

    // Pop loading
    AppNavigator.pop();

    if (result.isSuccess) {
      _userLocal.saveUser(result.value!);
      _user = result.value;
    }
  }

  Future<void> _handleLogOut() async {
    _userLocal.clearUser();
    await WaterbusSdk.instance.deleteToken();

    AppNavigator.popUntil(Routes.rootRoute);

    _user = null;
    AppBloc.userBloc.add(UserCleaned());
    AppBloc.recentJoinedBloc.add(RecentJoinedCleaned());
    AppBloc.chatBloc.add(ChatCleaned());
  }
}
