import 'package:flutter/material.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';

class TooltipWrapper extends StatelessWidget {
  final String? message;
  final Widget child;

  const TooltipWrapper({super.key, this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    if (message == null || context.isMobile) return child;

    return Tooltip(
      message: message,
      child: child,
    );
  }
}
