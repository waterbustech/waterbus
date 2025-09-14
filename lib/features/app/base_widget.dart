import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/core/utils/widgets/shadow_utils.dart';
import 'package:waterbus/features/home/presentation/widgets/logger_widget.dart';
import 'package:waterbus/gen/assets.gen.dart';

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
  final _terminalKey = GlobalKey<LoggerWidgetState>();
  late final ValueNotifier<bool> _controller = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
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
                  duration: const Duration(milliseconds: 260),
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
                      ? LoggerWidget(key: _terminalKey)
                      : const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          _controller.value = !_controller.value;
        },
        child: Container(
          margin: EdgeInsets.all(16.sp),
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(2.sp),
            boxShadow: ShadowUtils().shadowButton,
          ),
          child: Image.asset(
            Assets.icons.icLog.path,
            width: 20.sp,
            height: 20.sp,
            color: mCL,
          ),
        ),
      ),
    );
  }
}
