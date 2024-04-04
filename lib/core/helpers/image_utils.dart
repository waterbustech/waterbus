// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import 'package:waterbus/core/utils/path_helper.dart';

class ImageUtils {
  Future<Uint8List> reduceSize(String pathImage, {int quality = 80}) async {
    if (isNeedReduce(pathImage)) {
      if (kIsWeb) {
        final Uint8List? buffer = await FlutterImageCompress.compressWithFile(
          pathImage,
          quality: quality,
          numberOfRetries: 2,
        );

        return buffer ?? File(pathImage).readAsBytesSync();
      }

      final String? tempPath = await PathHelper.tempDirWaterbus;
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        pathImage,
        '$tempPath/${DateTime.now().microsecondsSinceEpoch}.jpeg',
        quality: quality,
        numberOfRetries: 2, // retry times when error
      );

      if (result != null) {
        return File(result.path).readAsBytesSync();
      }
    }

    return File(pathImage).readAsBytesSync();
  }

  bool isNeedReduce(String path) {
    final file = File(path);
    final int bytes = file.lengthSync();
    if (bytes <= 0) return false;
    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    if (i < 1) {
      if (i == 1 && size > 100) {
        return false;
      }

      return true;
    }
    return true;
  }
}
