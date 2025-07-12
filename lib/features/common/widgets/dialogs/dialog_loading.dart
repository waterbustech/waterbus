import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:waterbus/core/navigator/app_router.dart';

void displayLoadingLayer() {
  showDialog(
    context: AppRouter.context!,
    builder: (context) {
      return const PopScope(
        canPop: false,
        child: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    },
    barrierColor: const Color(0x80000000),
    barrierDismissible: false,
  );
}
