// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/chats/widgets/button_icon.dart';

class ChatsHeader extends StatelessWidget {
  const ChatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp).add(
        EdgeInsets.only(top: 12.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.sp),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.3.sp, color: colorPrimary),
                    shape: BoxShape.circle,
                  ),
                  child: CustomNetworkImage(
                    height: 30.sp,
                    width: 30.sp,
                    urlToImage:
                        'https://avatars.githubusercontent.com/u/60530946?v=4',
                  ),
                ),
                SizedBox(width: 10.sp),
                Text(
                  "Chat",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const ButtonIcon(
            icon: PhosphorIcons.gear_light,
          ),
          const ButtonIcon(
            icon: PhosphorIcons.chat_teardrop_dots_fill,
            colorBackground: colorPrimary,
          ),
          ButtonIcon(
            icon: PhosphorIcons.phone_light,
            margin: EdgeInsets.zero,
            colorBackground: colorBlack1,
            border: Border.all(
              width: 0.3.sp,
              color: colorGray2,
            ),
          ),
        ],
      ),
    );
  }
}
