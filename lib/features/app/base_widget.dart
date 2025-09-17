import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/home/presentation/widgets/logger_widget.dart';

class BaseWidget extends StatefulWidget {
  final bool isKeyboardVisible;
  final Widget? child;

  const BaseWidget({
    super.key,
    required this.isKeyboardVisible,
    this.child,
  });

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final _stackKey = GlobalKey();
  final _terminalKey = GlobalKey<LoggerWidgetState>();
  late final ValueNotifier<bool> _controller = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: context.isMobile
          ? null
          : FloatingActionButton.small(
              onPressed: () {
                _controller.value = !_controller.value;
              },
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Icon(
                LucideIcons.terminal,
                size: 16.sp,
              ),
            ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          key: _stackKey,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isKeyboardVisible) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: widget.child ?? const SizedBox(),
            ),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    )
                        .chain(CurveTween(curve: Curves.easeOutCubic))
                        .animate(anim);

                    return SlideTransition(
                      position: slide,
                      child: FadeTransition(opacity: anim, child: child),
                    );
                  },
                  child: value
                      ? Overlay(
                          initialEntries: [
                            OverlayEntry(
                              builder: (_) => LoggerWidget(key: _terminalKey),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
