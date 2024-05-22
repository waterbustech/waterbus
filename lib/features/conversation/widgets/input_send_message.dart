import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';

class InputSendMessage extends StatelessWidget {
  const InputSendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizerUtil.isDesktop ? 48.sp : null,
      width: 100.w,
      padding: SizerUtil.isDesktop
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.4,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 24.sp, right: 2.75.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: WebRTC.platformIsMobile
              ? Theme.of(context).colorScheme.surfaceContainerHighest
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
                    fontSize: 12.sp,
                  ),
                  filled: true,
                  fillColor: WebRTC.platformIsMobile
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
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
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    )
                  : null,
              padding: EdgeInsets.all(7.sp),
              child: Icon(
                PhosphorIcons.paper_plane_right_fill,
                color: WebRTC.platformIsMobile
                    ? mCL
                    : Theme.of(context).colorScheme.primary,
                size: SizerUtil.isDesktop ? 22.sp : 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
