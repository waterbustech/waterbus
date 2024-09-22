import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';

void displayLoadingLayer() {
  showDialog(
    routeSettings: const RouteSettings(name: Routes.loadingRoute),
    context: AppNavigator.context!,
    builder: (context) {
      return const PopScope(
        canPop: false,
        child: Center(
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
