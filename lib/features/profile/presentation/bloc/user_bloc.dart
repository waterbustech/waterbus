import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/failure_x.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';
import 'package:waterbus/features/profile/domain/entities/check_username_status.dart';

part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  // MARK: private
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  User? _user;
  CheckUsernameStatus _checkUsernameStatus = CheckUsernameStatus.none;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>(
      (event, emit) async {
        if (event is UserFetched) {
          if (_user != null) return;

          await _getUserProfile();

          if (_user != null) {
            emit(_userDone);
          }
        }

        if (event is UserUpdated) {
          await _updateUserProfile(event);

          if (_user != null) {
            emit(_userDone);
          }
        }

        if (event is UserAvatarUpdated) {
          await _handleChangeAvatar(event);

          if (_user != null) {
            emit(_userDone);
          }
        }

        if (event is UserCleaned) {
          _user = null;

          emit(UserInitial());
        }

        if (event is UserUsernameChecked) {
          _checkUsernameStatus = CheckUsernameStatus.checking;
          emit(_userDone);

          await _handleCheckUsername(event.username);
          emit(_userDone);
        }

        if (event is UserUsernameUpdated) {
          if (event.username == _user?.userName) return;

          await _handleUpdateUsername(event.username);

          emit(_userDone);
        }
      },
    );
  }

  // MARK: state
  UserDone get _userDone => UserDone(
        user: _user ?? kUserDefault,
        checkUsernameStatus: _checkUsernameStatus,
      );

  // MARK: private methods
  Future<void> _getUserProfile() async {
    final Result<User> result = await _waterbusSdk.getProfile();

    _user = result.value;
  }

  Future<void> _handleUpdateUsername(String username) async {
    final Result<bool> result =
        await _waterbusSdk.updateUsername(username: username);

    if (result.isSuccess) {
      _user = _user?.copyWith(userName: username);
      _checkUsernameStatus = CheckUsernameStatus.none;

      Strings.updateUsernameSuccessfully.i18n
          .showToast(ToastificationType.success);

      AppRouter.pop();
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _handleCheckUsername(String username) async {
    final Result<bool> result =
        await _waterbusSdk.checkUsername(username: username);

    _checkUsernameStatus = result.value ?? true
        ? CheckUsernameStatus.registered
        : CheckUsernameStatus.valid;
  }

  Future<void> _updateUserProfile(
    UserUpdated event, {
    bool ignorePop = false,
  }) async {
    if (_user == null) return;

    final Result<bool> result = await _waterbusSdk.updateProfile(
      user: _user!.copyWith(
        fullName: event.fullName,
        avatar: event.avatar,
        bio: event.bio ?? "",
      ),
    );

    AppRouter.pop();

    if (!ignorePop) {
      AppRouter.pop();
    }

    if (result.isSuccess) {
      _user = _user!.copyWith(
        fullName: event.fullName,
        avatar: event.avatar,
        bio: event.bio ?? "",
      );

      Strings.updatedPersonalInformationSuccessfully.i18n
          .showToast(ToastificationType.success);
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _handleChangeAvatar(UserAvatarUpdated event) async {
    final Result<PresignedUrl> presignedUrl =
        await _waterbusSdk.getPresignedUrl();

    if (presignedUrl.isSuccess) {
      final Result<String> sourceAvatar = await _waterbusSdk.uploadAvatar(
        presignedUrl: presignedUrl.value!.presignedUrl,
        sourceUrl: presignedUrl.value!.sourceUrl,
        image: event.image,
      );

      if (sourceAvatar.isSuccess) {
        await _updateUserProfile(
          UserUpdated(
            fullName: _user!.fullName,
            avatar: sourceAvatar.value ?? "",
            bio: _user?.bio,
          ),
          ignorePop: true,
        );
      }
    }
  }

  // MARK: export getter
  User? get user => _user;
  CheckUsernameStatus get checkUsernameStatus => _checkUsernameStatus;
}
