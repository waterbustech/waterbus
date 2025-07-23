import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/gen/assets.gen.dart';

class EmptyMeetView extends StatelessWidget {
  const EmptyMeetView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Assets.images.worldMap.image(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 20.sp),
          GestureWrapper(
            onTap: () async {
              await launchUrl(Uri.parse(kGithubRepo));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.sp,
                horizontal: 16.sp,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.sp,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: 14.sp,
                    fill: 1,
                  ),
                  Text(
                    Strings.supportUs.i18n,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.1,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
