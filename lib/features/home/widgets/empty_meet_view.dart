import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
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
        spacing: 20.sp,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.placeHolder.image(
            width: context.isDesktop ? 600.sp : 300.sp,
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20.sp),
            child: Column(
              spacing: 6.sp,
              children: [
                Text(
                  "Open-source. Self-hosted. For devs.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Support us by giving a ⭐️ or becoming a 💖 sponsor on GitHub!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
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
