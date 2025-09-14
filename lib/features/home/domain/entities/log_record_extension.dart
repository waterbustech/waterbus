import 'package:flutter/material.dart';

import 'package:logging/logging.dart';

import 'package:waterbus/core/navigator/app_router.dart';

extension LogRecordX on LogRecord {
  Color get leverColor {
    if (level == Level.INFO) return Colors.green;
    if (level == Level.WARNING) return Colors.orange;
    if (level == Level.SEVERE) return Colors.red;
    if (level == Level.SHOUT) return Colors.purple;
    if (level.value <= Level.FINE.value) {
      return Theme.of(AppRouter.context!).textTheme.bodyMedium!.color!;
    }
    return Colors.white;
  }
}
