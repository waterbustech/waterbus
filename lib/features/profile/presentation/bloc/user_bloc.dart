// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/error/failures.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/profile/domain/entities/check_username_status.dart';

part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  // MARK: private
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
        user: _user!,
        checkUsernameStatus: _checkUsernameStatus,
      );

  // MARK: private methods
  Future<void> _getUserProfile() async {
    final Either<Failure, User> user = await WaterbusSdk.instance.getProfile();

    user.fold(
      (l) => {},
      (r) => _user = r,
    );
  }

  Future<void> _handleUpdateUsername(String username) async {
    final Either<Failure, bool> result =
        await WaterbusSdk.instance.updateUsername(username: username);

    result.fold((l) => {}, (r) {
      if (r) {
        _user = _user?.copyWith(userName: username);
        _checkUsernameStatus = CheckUsernameStatus.none;

        AppNavigator.pop();
      }
    });
  }

  Future<void> _handleCheckUsername(String username) async {
    final Either<Failure, bool> result =
        await WaterbusSdk.instance.checkUsername(username: username);

    result.fold(
      (l) => {},
      (r) => _checkUsernameStatus =
          r ? CheckUsernameStatus.registered : CheckUsernameStatus.valid,
    );
  }

  Future<void> _updateUserProfile(
    UpdateProfileEvent event, {
    bool ignorePop = false,
  }) async {
    if (_user == null) return;

    final Either<Failure, User> user = await WaterbusSdk.instance.updateProfile(
      user: _user!.copyWith(
        fullName: event.fullName,
        avatar: event.avatar,
        bio: event.bio ?? "",
      ),
    );

    AppNavigator.pop();

    user.fold(
      (l) => {},
      (r) {
        if (!ignorePop) {
          AppNavigator.pop();
        }

        return _user = r;
      },
    );
  }

  Future<void> _handleChangeAvatar(UpdateAvatarEvent event) async {
    final String? presignedUrl = await _getPresignedUrlS3();

    if (presignedUrl == null) return;

    final Either<Failure, String> uploadAvatar = await WaterbusSdk.instance
        .uploadAvatar(uploadUrl: presignedUrl, image: event.image);

    final String? urlToImage = uploadAvatar.fold((l) => null, (r) => r);

    if (urlToImage == null) return;

    await _updateUserProfile(
      UpdateProfileEvent(
        fullName: _user!.fullName,
        avatar: urlToImage,
        bio: _user?.bio,
      ),
      ignorePop: true,
    );
  }

  Future<String?> _getPresignedUrlS3() async {
    final Either<Failure, String> presignedUrl =
        await WaterbusSdk.instance.getPresignedUrl();

    return presignedUrl.fold(
      (failure) => null,
      (url) => url,
    );
  }

  // MARK: export getter
  User? get user => _user;
  CheckUsernameStatus get checkUsernameStatus => _checkUsernameStatus;
}
