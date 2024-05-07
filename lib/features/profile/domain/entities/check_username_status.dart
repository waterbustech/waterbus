// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/localization.dart';

enum CheckUsernameStatus {
  none,
  checking,
  registered,
  valid,
}

extension CheckUsernameStatusX on CheckUsernameStatus {
  Color get colorByStatus {
    switch (this) {
      case CheckUsernameStatus.valid:
        return Colors.green;
      case CheckUsernameStatus.registered:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get titleByStatus {
    switch (this) {
      case CheckUsernameStatus.valid:
        return Strings.canUseUsername.i18n;
      case CheckUsernameStatus.registered:
        return Strings.usernameUsed.i18n;
      default:
        return "${Strings.checking.i18n}...";
    }
  }
}
