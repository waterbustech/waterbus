import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';

class AppFileSaver {
  Future<void> saveFile(Uint8List bytes, String extension) async {
    await FileSaver.instance.saveFile(
      name: 'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
      bytes: bytes,
      ext: extension,
      mimeType: MimeType.png,
    );
  }
}
