// Package imports:
import 'package:hive/hive.dart';
import 'package:waterbus/core/constants/storage_keys.dart';

// Project imports:
import 'package:waterbus/core/utils/path_helper.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    final String path = await PathHelper.localStoreDirStreamOS;
    Hive.init(path);
    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Hive.openBox(StorageKeys.boxAuth);
  }
}
