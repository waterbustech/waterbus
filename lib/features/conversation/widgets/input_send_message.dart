// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';

class InputSendMessage extends StatelessWidget {
  const InputSendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: WebRTC.platformIsMobile
          ? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.3.sp, color: colorGreyWhite),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 24.sp, right: 2.75.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: WebRTC.platformIsMobile
              ? Colors.grey.shade800
              : Colors.transparent,
          borderRadius: WebRTC.platformIsMobile
              ? BorderRadius.circular(30.sp)
              : BorderRadius.zero,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  color: mCL,
                  fontSize: 12.sp,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                  ),
                  hintText: 'Leave a message...',
                  hintStyle: TextStyle(
                    color: mC,
                    fontSize: 12.sp,
                  ),
                  filled: true,
                  fillColor: WebRTC.platformIsMobile
                      ? Colors.grey.shade800
                      : Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: WebRTC.platformIsMobile
                        ? BorderRadius.circular(40.sp)
                        : BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                  hoverColor: Colors.transparent,
                ),
                onChanged: (val) {},
              ),
            ),
            Container(
              decoration: WebRTC.platformIsMobile
                  ? BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    )
                  : null,
              padding: EdgeInsets.all(7.sp),
              child: Icon(
                PhosphorIcons.paper_plane_right_fill,
                color: WebRTC.platformIsMobile
                    ? mCL
                    : Theme.of(context).primaryColor,
                size: SizerUtil.isDesktop ? 22.sp : 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
