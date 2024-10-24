import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/chats/presentation/bloc/invited_chat_bloc.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/data/datasources/user_local_datasource.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLocalDataSource _userLocal;
  final Auth _auth = Auth();

  User? _user;

  AuthBloc(this._userLocal) : super(AuthInitial()) {
    _auth.initialize((payload) async {
      final User? user = await WaterbusSdk.instance.createToken(payload);

      // Pop loading
      AppNavigator.pop();

      if (user != null) {
        _userLocal.saveUser(user);
        _user = user;
      }

      add(OnAuthCheckEvent());
    });

    on<AuthEvent>((event, emit) async {
      if (event is OnAuthCheckEvent) {
        await _onAuthCheck(emit);
      }

      if (event is LogInWithGoogleEvent || event is LogInAnonymously) {
        await _handleLogin(event);

        if (_user != null) emit(_authSuccess);
      }

      if (event is LogOutEvent) {
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
  AuthSuccess get _authSuccess {
    AppBloc.instance.bootstrap();

    return AuthSuccess();
  }

  AuthFailure get _authFailure {
    _auth.signInSilently();

    return AuthFailure();
  }

  // MARK: Private methods
  Future<void> _handleLogin(AuthEvent event) async {
    displayLoadingLayer();

    late final AuthPayloadModel? payload;

    switch (event) {
      case LogInWithGoogleEvent():
        payload = await _auth.signInWithGoogle();
        break;
      case LogInAnonymously():
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
    final User? user = await WaterbusSdk.instance.createToken(payload);

    // Pop loading
    AppNavigator.pop();

    if (user != null) {
      _userLocal.saveUser(user);
      _user = user;
    }
  }

  Future<void> _handleLogOut() async {
    _userLocal.clearUser();
    await WaterbusSdk.instance.deleteToken();

    AppNavigator.popUntil(Routes.rootRoute);

    _user = null;
    AppBloc.userBloc.add(CleanProfileEvent());
    AppBloc.recentJoinedBloc.add(CleanAllRecentJoinedEvent());
    AppBloc.chatBloc.add(CleanChatEvent());
    AppBloc.invitedChatBloc.add(CleanInvitedConversationEvent());
  }
}
