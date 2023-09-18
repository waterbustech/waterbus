// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/gen/assets.gen.dart';

class E2eeBottomSheet extends StatelessWidget {
  const E2eeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        children: [
          SizedBox(height: 40.sp),
          Image.asset(
            Assets.images.imgLogo.path,
            width: 200.sp,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 16.sp),
          Text(
            'Your messages and meetings are private',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.sp),
          Text(
            'End-to-end encryption keeps your personal meetings between you and the other participants. Not event Waterbus can listen to them. This includes your:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
