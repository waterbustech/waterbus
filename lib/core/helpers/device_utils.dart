import 'package:flutter/services.dart';

class DeviceUtils {
  void lightImpact() {
    HapticFeedback.lightImpact();
  }

  void heavyImpact() {
    HapticFeedback.heavyImpact();
  }
}
