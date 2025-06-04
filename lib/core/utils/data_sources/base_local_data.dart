import 'package:hive_ce/hive.dart';
import 'package:waterbus_sdk/utils/path_helper.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    final String? path = await PathHelper.localStoreDirWaterbus;
    Hive.init(path);

    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Hive.openBox(StorageKeys.boxAuth);
    await Hive.openBox(StorageKeys.boxRoom);
    await Hive.openBox(StorageKeys.boxMediaConfig);
    await Hive.openBox(StorageKeys.boxAppSettings);
  }
}
