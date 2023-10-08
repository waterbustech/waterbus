// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/usecases/get_presigned_url.dart';
import 'package:waterbus/features/profile/domain/usecases/get_profile.dart';
import 'package:waterbus/features/profile/domain/usecases/update_profile.dart';
import 'package:waterbus/features/profile/domain/usecases/upload_avatar.dart';

part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final GetPresignedUrl _getPresignedUrl;
  final UploadAvatar _uploadAvatar;

  // MARK: private
  User? _user;

  UserBloc(
    this._updateProfile,
    this._getPresignedUrl,
    this._getProfile,
    this._uploadAvatar,
  ) : super(UserInitial()) {
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
      },
    );
  }

  // MARK: state
  UserGetDone get _userGetDone => UserGetDone(user: _user!);

  // MARK: private methods
  Future<void> _getUserProfile() async {
    final Either<Failure, User> user = await _getProfile.call(null);

    user.fold(
      (l) => {},
      (r) => _user = r,
    );
  }

  Future<void> _updateUserProfile(
    UpdateProfileEvent event, {
    bool ignorePop = false,
  }) async {
    if (_user == null) return;

    final Either<Failure, User> user = await _updateProfile.call(
      UpdateUserParams(
        user: _user!.copyWith(
          fullName: event.fullName,
          avatar: event.avatar,
        ),
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

    final Either<Failure, String> uploadAvatar = await _uploadAvatar.call(
      UploadAvatarParams(
        uploadUrl: presignedUrl,
        image: event.image,
      ),
    );

    final String? urlToImage = uploadAvatar.fold((l) => null, (r) => r);

    if (urlToImage == null) return;

    await _updateUserProfile(
      UpdateProfileEvent(fullName: _user!.fullName, avatar: urlToImage),
      ignorePop: true,
    );
  }

  Future<String?> _getPresignedUrlS3() async {
    final Either<Failure, String> presignedUrl =
        await _getPresignedUrl.call(null);

    return presignedUrl.fold(
      (failure) => null,
      (url) => url,
    );
  }

  // MARK: export getter
  User? get user => _user;
}
