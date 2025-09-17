import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

Widget showDropdownButton<T>({
  required List<T> data,
  required T? currentData,
  void Function(T?)? onChanged,
  required List<DropdownMenuItem<T>>? items,
  Widget? customButton,
  double? width,
  Widget? hint,
  double? menuHeight,
  Offset? offset,
}) {
  return Theme(
    data: Theme.of(AppRouter.context!).copyWith(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Theme.of(AppRouter.context!)
          .colorScheme
          .primary
          .withValues(alpha: 0.08),
      focusColor: Colors.transparent,
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        hint: hint,
        isExpanded: true,
        items: items,
        value: currentData,
        onChanged: onChanged,
        customButton: customButton,
        menuItemStyleData: MenuItemStyleData(
          height: menuHeight ?? 48.0,
          selectedMenuItemBuilder: (context, child) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.sp)),
              child: Row(
                children: [
                  Expanded(child: child),
                  Padding(
                    padding: EdgeInsets.only(right: 14.sp),
                    child: Icon(
                      PhosphorIcons.check(),
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        iconStyleData: IconStyleData(
          icon: PhosphorIcon(
            PhosphorIcons.caretUpDown(),
            size: 12.sp,
            color: Theme.of(AppRouter.context!).textTheme.bodyMedium!.color,
          ),
          iconSize: 12.sp,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 5.sp),
          width: width ?? 250.sp,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(AppRouter.context!).dividerColor,
            ),
            borderRadius: BorderRadius.circular(4.sp),
            color: Theme.of(AppRouter.context!).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 4,
                spreadRadius: 0.4,
                color:
                    Theme.of(AppRouter.context!).brightness == Brightness.dark
                        ? Colors.black12.withValues(alpha: 0.2)
                        : mCU.withValues(alpha: 0.8),
              ),
            ],
          ),
          offset: offset ?? const Offset(0, -4),
          scrollbarTheme: ScrollbarThemeData(radius: Radius.circular(2.sp)),
        ),
      ),
    ),
  );
}
