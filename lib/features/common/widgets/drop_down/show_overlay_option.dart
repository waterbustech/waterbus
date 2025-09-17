import 'package:flutter/material.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

OverlayEntry showOverlayOption<T>(
  BuildContext context, {
  required List<T> options,
  required GlobalKey key,
  double? width,
  double? height,
  T? selected,
  OverlayEntry? overlay,
  required Function(T)? onSelectOption,
  required Function() removeOverlay,
  required Widget Function(T)? item,
}) {
  if (overlay != null) return overlay;

  OverlayEntry? overlayCurrent = overlay;

  final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;

  final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

  overlayCurrent = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          GestureDetector(
            onTap: removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: buttonPosition.dx,
            top: buttonPosition.dy -
                options.length * (height ?? 32.sp) -
                5.sp -
                8.sp * 2,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4.sp),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.sp),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                padding: EdgeInsets.all(6.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(options.length, (index) {
                    return ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(4.sp),
                      child: GestureWrapper(
                        isHovered: true,
                        onTap: () => onSelectOption?.call(options[index]),
                        child: Container(
                          width: width ?? 225.sp,
                          height: height ?? 32.sp,
                          padding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 10.sp,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.sp),
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.centerLeft,
                          child: item?.call(options[index]) ?? SizedBox(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Overlay.of(context).insert(overlayCurrent);

  return overlayCurrent;
}
