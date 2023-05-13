// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';

showDialogLoading() {
  showDialog(
    routeSettings: const RouteSettings(name: Routes.loadingRoute),
    context: AppNavigator.context!,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 15,
          ),
        ),
      );
    },
    barrierColor: const Color(0x80000000),
    barrierDismissible: false,
  );
}
