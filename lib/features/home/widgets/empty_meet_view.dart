// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/gen/assets.gen.dart';

class EmptyMeetView extends StatelessWidget {
  const EmptyMeetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Assets.images.worldMap.image(),
        ),
        SizedBox(height: 20.sp),
        GestureWrapper(
          onTap: () async {
            await launchUrl(Uri.parse(kGithubRepo));
          },
          child: Material(
            shape: SuperellipseShape(
              borderRadius: BorderRadius.circular(20.sp),
            ),
            clipBehavior: Clip.hardEdge,
            color: Colors.yellow,
            child: Container(
              width: 120.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.icGithub.image(
                    width: 20.sp,
                    height: 20.sp,
                  ),
                  SizedBox(width: 6.sp),
                  Text(
                    "Give us star",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.sp),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.sp),
      ],
    );
  }
}
