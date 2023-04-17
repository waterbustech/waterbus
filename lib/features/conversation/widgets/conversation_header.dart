// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/widgets/button_icon.dart';

class ConversationHeader extends StatelessWidget {
  const ConversationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Row(
        children: [
          GestureWrapper(
            onTap: () {
              AppNavigator.pop();
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 12.sp).add(
                EdgeInsets.only(right: 10.sp),
              ),
              child: Icon(
                PhosphorIcons.caret_left_light,
                size: 18.sp,
                color: mCL,
              ),
            ),
          ),
          CustomNetworkImage(
            height: 35.sp,
            width: 35.sp,
            urlToImage:
                'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
          ),
          SizedBox(width: 10.sp),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Marzuki Ali',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: colorGreenLight,
                      fontSize: 10.sp,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Spacer(),
          ButtonIcon(
            icon: PhosphorIcons.video_camera_light,
            sizeIcon: 22.sp,
            padding: EdgeInsets.all(3.sp),
            margin: EdgeInsets.zero,
          ),
          SizedBox(width: 5.sp),
          ButtonIcon(
            icon: PhosphorIcons.phone_light,
            sizeIcon: 20.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp)
                .add(EdgeInsets.only(left: 5.sp)),
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
