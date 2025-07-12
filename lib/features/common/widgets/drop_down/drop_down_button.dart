import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

Widget showDropdownButton<T>({
  required List<T> data,
  required T? currentData,
  void Function(T?)? onChanged,
  required List<DropdownMenuItem<T>>? items,
  ButtonStyleData? buttonStyleData,
  Widget? customButton,
  double? width,
}) {
  return Theme(
    data: Theme.of(AppRouter.context!).copyWith(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        items: items,
        value: currentData,
        onChanged: onChanged,
        customButton: customButton,
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) {
            return Row(
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
          width: 250.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            color: Theme.of(AppRouter.context!).colorScheme.surfaceContainer,
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
          offset: const Offset(0, -4),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(12.sp),
          ),
        ),
      ),
    ),
  );
}
