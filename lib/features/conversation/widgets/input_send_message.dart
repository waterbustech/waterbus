// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/chats/widgets/button_icon.dart';

class InputSendMessage extends StatelessWidget {
  const InputSendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.3.sp, color: colorGreyWhite),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorTitle,
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Row(
          children: [
            ButtonIcon(
              margin: EdgeInsets.only(right: 10.sp, left: 5.sp),
              icon: PhosphorIcons.smiley_light,
              sizeIcon: 22.sp,
              colorIcon: colorGray2,
            ),
            Container(
              height: 22.sp,
              width: 1.sp,
              color: colorGray2,
            ),
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
                  hintText: 'Type something...',
                  hintStyle: TextStyle(
                    color: colorGreyWhite,
                    fontSize: 12.sp,
                  ),
                  filled: true,
                  fillColor: colorTitle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    gapPadding: 0,
                  ),
                ),
                onChanged: (val) {},
              ),
            ),
            ButtonIcon(
              icon: PhosphorIcons.microphone_light,
              sizeIcon: 22.sp,
              colorIcon: colorGray2,
              margin: EdgeInsets.only(right: 10.sp),
            ),
            Container(
              decoration: const BoxDecoration(
                color: colorPrimary,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(7.sp),
              child: Icon(
                PhosphorIcons.paper_plane_right_fill,
                color: mCL,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
