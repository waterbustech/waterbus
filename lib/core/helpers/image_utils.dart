// Dart imports:
import 'dart:io';
import 'dart:math';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import 'package:waterbus/core/utils/path_helper.dart';

class ImageUtils {
  Future<File> reduceSize(String pathImage, {int quality = 80}) async {
    if (isNeedReduce(pathImage)) {
      final String tempPath = await PathHelper.tempDirWaterbus;
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        pathImage,
        '$tempPath/${DateTime.now().microsecondsSinceEpoch}.jpeg',
        quality: quality,
        numberOfRetries: 2, // retry times when error
      );

      if (result != null) {
        return File(result.path);
      }
    }

    return File(pathImage);
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
