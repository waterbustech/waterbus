import 'package:flutter/material.dart';

Future showBottomSheetWaterbus({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Color? barrierColor,
  Color? backgroundColor,
  bool isScrollControlled = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? Colors.transparent,
    barrierColor: barrierColor ?? Colors.black38,
    enableDrag: enableDrag,
    builder: builder,
  );
}
