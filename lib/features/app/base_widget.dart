import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/core/utils/widgets/shadow_utils.dart';
import 'package:waterbus/features/home/presentation/widgets/draggable_box.dart';
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
  final _stackKey = GlobalKey();
  final _terminalKey = GlobalKey<LoggerWidgetState>();
  late final ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
  final Size _boxSize = Size(40.sp, 40.sp);
  final EdgeInsets _margin = EdgeInsets.all(16.sp);

  Offset _fabLikeInitialOffset(
    BuildContext context, {
    required Size boxSize,
    required EdgeInsets margin,
  }) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Offset(
      w - margin.right * 2 - boxSize.width,
      h - mq.padding.bottom - margin.bottom * 2 - boxSize.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            DraggableBox(
              snap: false,
              size: _boxSize,
              margin: _margin,
              initialOffset: _fabLikeInitialOffset(
                context,
                boxSize: _boxSize,
                margin: _margin,
              ),
              onTap: () {
                _controller.value = !_controller.value;
              },
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(2.sp),
                boxShadow: ShadowUtils().shadowButton,
              ),
              parentKey: _stackKey,
              child: Container(
                padding: EdgeInsets.all(10.sp),
                alignment: Alignment.center,
                child: Image.asset(
                  Assets.icons.icLog.path,
                  width: 20.sp,
                  height: 20.sp,
                  color: mCL,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
