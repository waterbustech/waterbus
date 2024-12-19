import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/result.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
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
        if (event is GetProfileEvent) {
          if (_user != null) return;

          await _getUserProfile();

          if (_user != null) {
            emit(_userGetDone);
          }
        }

        if (event is UpdateProfileEvent) {
          await _updateUserProfile(event);

          if (_user != null) {
            emit(_userGetDone);
          }
        }

        if (event is UpdateAvatarEvent) {
          await _handleChangeAvatar(event);

          if (_user != null) {
            emit(_userGetDone);
          }
        }

        if (event is CleanProfileEvent) {
          _user = null;

          emit(UserInitial());
        }

        if (event is CheckUsernameEvent) {
          _checkUsernameStatus = CheckUsernameStatus.checking;
          emit(_userGetDone);

          await _handleCheckUsername(event.username);
          emit(_userGetDone);
        }

        if (event is UpdateUsernameEvent) {
          if (event.username == _user?.userName) return;

          await _handleUpdateUsername(event.username);

          emit(_userGetDone);
        }
      },
    );
  }

  // MARK: state
  UserGetDone get _userGetDone => UserGetDone(
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

      showSnackBarWaterbus(content: Strings.updateUsernameSuccessfully.i18n);

      AppNavigator.pop();
    } else {
      // Toast failure
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
    UpdateProfileEvent event, {
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

    AppNavigator.pop();

    if (!ignorePop) {
      AppNavigator.pop();
    }

    if (result.isSuccess) {
      _user = _user!.copyWith(
        fullName: event.fullName,
        avatar: event.avatar,
        bio: event.bio ?? "",
      );

      showSnackBarWaterbus(
        content: Strings.updatedPersonalInformationSuccessfully.i18n,
      );
    } else {
      // Toast failure
    }
  }

  Future<void> _handleChangeAvatar(UpdateAvatarEvent event) async {
    final Result<String> presignedUrl = await _waterbusSdk.getPresignedUrl();

    if (presignedUrl.isSuccess) {
      final Result<String> uploadAvatar = await _waterbusSdk.uploadAvatar(
        uploadUrl: presignedUrl.value ?? "",
        image: event.image,
      );

      if (uploadAvatar.isSuccess) {
        await _updateUserProfile(
          UpdateProfileEvent(
            fullName: _user!.fullName,
            avatar: uploadAvatar.value ?? "",
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
