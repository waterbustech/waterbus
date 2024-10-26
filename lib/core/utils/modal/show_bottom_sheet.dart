import 'package:flutter/material.dart';

import 'package:waterbus/core/navigator/app_routes.dart';

Future showBottomSheetWaterbus({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Color? barrierColor,
  Color? backgroundColor,
  bool isScrollControlled = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet(
    routeSettings: const RouteSettings(name: Routes.bottomSheetRoute),
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? Colors.transparent,
    barrierColor: barrierColor ?? Colors.black38,
    enableDrag: enableDrag,
    builder: builder,
  );
}
