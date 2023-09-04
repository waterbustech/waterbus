// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class MeetView extends StatelessWidget {
  final BoxDecoration? decoration;
  final EdgeInsets? margin;
  final String displayName;
  const MeetView({
    super.key,
    required this.displayName,
    this.decoration,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Stack(
        children: [
          Container(
            decoration: decoration,
          ),
          Positioned(
            left: 10.sp,
            bottom: 10.sp,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.sp,
                vertical: 8.sp,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                color: Colors.black.withOpacity(.3),
              ),
              alignment: Alignment.center,
              child: Text(
                displayName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
