import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/meeting/presentation/widgets/e2ee_label_line.dart';
import 'package:waterbus/gen/assets.gen.dart';

class E2eeBottomSheet extends StatelessWidget {
  const E2eeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40.sp),
          Image.asset(
            Assets.images.imgLogo.path,
            width: 200.sp,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 16.sp),
          Text(
            Strings.yourMessagesAndMeetingsArePrivate.i18n,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.sp),
          Text(
            Strings
                .endToEndEncryptionKeepsYourPersonalMeetingsBetweenYouAndTheOtherPeopleNotEvenWaterbusCanListenToThemThisIncludesYour
                .i18n,
            textAlign: TextAlign.justify,
            strutStyle: StrutStyle.disabled,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.sp),
          E2eeLabelLine(
            icon: PhosphorIcons.video_camera,
            label: Strings.audioAndVideoCalls.i18n,
          ),
          SizedBox(height: 8.sp),
          E2eeLabelLine(
            icon: PhosphorIcons.chats_teardrop,
            label: Strings.textMessages.i18n,
          ),
          SizedBox(height: 40.sp),
        ],
      ),
    );
  }
}
