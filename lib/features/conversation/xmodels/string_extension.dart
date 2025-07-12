import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

extension StringExtension on String {
  String formatVietnamese() {
    var result = this;
    for (int i = 0; i < vietnameseRegex.length; i++) {
      result = result.replaceAll(
        vietnameseRegex[i],
        i > vietnamese.length - 1 ? '' : vietnamese[i],
      );
    }
    return result;
  }

  void showToast(ToastificationType type) {
    toastification.show(
      title: Text(
        this,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11.sp,
          color: Theme.of(AppRouter.context!).textTheme.bodyMedium!.color,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      backgroundColor: Theme.of(AppRouter.context!).scaffoldBackgroundColor,
      autoCloseDuration: 2000.milliseconds,
      type: type,
      alignment: AppRouter.context!.isDesktop
          ? Alignment.topRight
          : Alignment.topCenter,
      style: ToastificationStyle.flat,
      showProgressBar: false,
      borderSide: BorderSide(
        color: type == ToastificationType.error ? colorRedOrange : Colors.green,
        width: 1.sp,
      ),
      closeOnClick: true,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.none,
      ),
    );
  }

  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
