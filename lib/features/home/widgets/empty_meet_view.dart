// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
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
        Image.asset(
          Assets.images.dash.path,
          height: 200.sp,
          width: 200.sp,
        ),
        SizedBox(height: 20.sp),
        GestureWrapper(
          onTap: () async {
            await launchUrl(Uri.parse(kGithubRepo));
          },
          child: Container(
            width: 120.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.sp),
            ),
            alignment: Alignment.center,
            child: Text(
              "Give us star ⭐",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
