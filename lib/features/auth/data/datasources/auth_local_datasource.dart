// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  UserModel? getUserModel();
  void saveUserModel(UserModel userModel);
  void saveTokens({
    required String? accessToken,
    required String? refreshToken,
  });
  void clearUser();

  String? get accessToken;
  String? get refreshToken;
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxAuth);

  @override
  void clearUser() {
    hiveBox.delete(StorageKeys.userModel);
  }

  @override
  UserModel? getUserModel() {
    final String? raw = hiveBox.get(StorageKeys.userModel);

    if (raw == null) return null;

    return UserModel.fromJson(raw);
  }

  @override
  void saveUserModel(UserModel userModel) {
    hiveBox.put(StorageKeys.userModel, userModel.toJson());
  }

  @override
  void saveTokens({
    required String? accessToken,
    required String? refreshToken,
  }) {
    final UserModel? user = getUserModel();

    if (user == null) return;

    saveUserModel(
      user.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  String? get accessToken => getUserModel()?.accessToken;

  @override
  String? get refreshToken => getUserModel()?.refreshToken;
}
