import 'package:flutter/material.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

OverlayEntry showOverlayOption<T>(
  BuildContext context, {
  required List<T> options,
  required GlobalKey key,
  double? width,
  double? height,
  Offset? offset,
  T? selected,
  required LayerLink layerLink,
  OverlayEntry? overlay,
  required Function(T)? onSelectOption,
  required Function() removeOverlay,
  required Widget Function(T)? item,
}) {
  OverlayEntry? overlayCurrent = overlay;

  if (overlayCurrent != null) return overlayCurrent;

  overlayCurrent = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          GestureDetector(
            onTap: removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: offset ?? Offset(0, -32.sp * options.length - 20.sp),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8.sp),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                padding: EdgeInsets.all(6.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(options.length, (index) {
                    return ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(8.sp),
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
                            borderRadius: BorderRadius.circular(8.sp),
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
