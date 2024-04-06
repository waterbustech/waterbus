// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';

class InputSendMessage extends StatelessWidget {
  const InputSendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.3.sp, color: colorGreyWhite),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 24.sp, right: 2.75.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(30.sp),
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
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.sp),
                    borderSide: BorderSide.none,
                  ),
                  hoverColor: Colors.transparent,
                ),
                onChanged: (val) {},
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
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
