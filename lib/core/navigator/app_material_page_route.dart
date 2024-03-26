// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';

class AppMaterialPageRoute<T> extends MaterialPageRoute<T> {
  AppMaterialPageRoute({
    required super.builder,
    required RouteSettings super.settings,
  });

  @override
  @protected
  bool get hasScopedWillPopCallback {
    return AppNavigator.canPop;
  }
}
