// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<void> deleteCacheImageDir(String path) async {
    final cacheDir = Directory(path);
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> createDirWaterbus() async {
    final String tempWaterbusDir = await tempDirWaterbus;
    final String localStoreWaterbusDir = await localStoreDirWaterbus;
    final Directory myDir = Directory(tempWaterbusDir);
    final Directory localDir = Directory(localStoreWaterbusDir);
    final Directory appDirectory = await appDir;
    if (!myDir.existsSync()) {
      await myDir.create();
    }

    if (!localDir.existsSync()) {
      await localDir.create();
    }

    if (!appDirectory.existsSync()) {
      await appDirectory.create();
    }
  }

  static Future<String> get tempDirWaterbus async =>
      '${(await getTemporaryDirectory()).path}/Waterbus';

  static Future<String> get localStoreDirWaterbus async =>
      '${(await getTemporaryDirectory()).path}/hive';

  static Future<Directory> get appDir async =>
      await getApplicationDocumentsDirectory();

  static Future<Directory?> get downloadsDir async {
    Directory downloadsDirectory;
    try {
      if (Platform.isIOS) {
        downloadsDirectory = await getLibraryDirectory();
      } else {
        downloadsDirectory = await getApplicationSupportDirectory();
      }

      return downloadsDirectory;
    } on PlatformException {
      return null;
    }
  }

  static Future<int> getTempSize() async {
    final String tempWaterbusDir = await tempDirWaterbus;
    final Directory myDir = Directory(tempWaterbusDir);

    if (!myDir.existsSync()) return 0;

    return myDir.listSync().isEmpty ? 0 : ((myDir.statSync().size - 64) * 1024);
  }

  static Future<void> clearTempDir() async {
    final String tempWaterbusDir = await tempDirWaterbus;
    final Directory myDir = Directory(tempWaterbusDir);

    if (!myDir.existsSync()) return;

    myDir.deleteSync(recursive: true);
    myDir.create();
  }
}
