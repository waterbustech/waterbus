import 'package:flutter/foundation.dart';

import 'package:universal_io/io.dart';

class PlatformUtils {
  static bool get isDesktop {
    if (kIsWeb) return false;

    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  static bool get isMobile {
    if (kIsWeb) return false;

    return Platform.isIOS || Platform.isAndroid;
  }

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
}
