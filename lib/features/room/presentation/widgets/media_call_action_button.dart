import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';
import 'package:waterbus/features/room/presentation/widgets/call_action_button.dart';

class MediaCallActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  final Function()? onSelectMediaDevice;
  final String settingTooltipMessage;
  final String tooltipMessage;

  const MediaCallActionButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.onSelectMediaDevice,
    required this.settingTooltipMessage,
    required this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? CallActionButton(
            icon: icon,
            onTap: () {
              onTap?.call();
            },
          )
        : Container(
            width: 84.sp,
            margin: EdgeInsets.only(left: 8.sp),
            decoration: ShapeDecoration(
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(25.sp),
              ),
              color: Color.alphaBlend(
                Colors.white.withValues(alpha: .1),
                Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            height: 42.sp,
            child: Row(
              children: [
                Expanded(
                  child: TooltipWrapper(
                    message: settingTooltipMessage,
                    child: GestureWrapper(
                      onTap: onTap,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Icon(
                          icon,
                          color: Theme.of(context).iconTheme.color,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TooltipWrapper(
                    message: tooltipMessage,
                    child: GestureWrapper(
                      onTap: onSelectMediaDevice,
                      child: Material(
                        clipBehavior: Clip.hardEdge,
                        shape: SuperellipseShape(
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(
                            PhosphorIcons.caretDown(),
                            color: Theme.of(context).iconTheme.color,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
