// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class VersionInfoFooter extends StatelessWidget {
  const VersionInfoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 12.sp),
      child: Column(
        children: [
          Text(
            'Waterbus Version: 1.1.1',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.25.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.sp),
          GestureWrapper(
            onTap: () async {
              await launchUrl(Uri.parse(kWaterbusDocs));
            },
            child: Text(
              '@Waterbus.tech',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.25.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
