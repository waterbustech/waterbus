import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class UserLocalDataSource {
  User? getUser();
  void saveUser(User user);
  void clearUser();
}

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxAuth);

  @override
  void clearUser() {
    hiveBox.delete(StorageKeys.user);
  }

  @override
  User? getUser() {
    final String? raw = hiveBox.get(StorageKeys.user);

    if (raw == null) return null;

    return User.fromJson(raw);
  }

  @override
  void saveUser(User user) {
    hiveBox.put(StorageKeys.user, user.toJson());
  }
}
