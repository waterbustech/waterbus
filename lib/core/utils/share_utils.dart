import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import 'package:waterbus/core/utils/device_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

class ShareUtils {
  Future<void> share({
    String link = '',
    String title = 'Waterbus: Online Meeting',
    String? description,
  }) async {
    DeviceUtils().lightImpact();

    await Share.share(
      link,
      subject: title,
      sharePositionOrigin: Rect.fromLTWH(
        0,
        0,
        100.w,
        10.h,
      ),
    );
  }
}
