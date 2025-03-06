import 'dart:typed_data';

import 'package:web/web.dart' as web;

class AppFileSaver {
  Future<void> saveFile(Uint8List bytes, String extension) async {
    web.HTMLAnchorElement()
      ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
      ..download =
          'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
      ..style.display = 'none'
      ..click();
  }
}
