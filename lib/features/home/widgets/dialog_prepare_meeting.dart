// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/home/widgets/time_card.dart';
import 'package:waterbus/features/meeting/widgets/call_action_button.dart';

class DialogPrepareMeeting extends StatelessWidget {
  const DialogPrepareMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 265.sp,
                    height: 200.sp,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.sp),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://avatars.githubusercontent.com/u/60530946?v=4',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.sp,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CallActionButton(
                          icon: PhosphorIcons.microphone_bold,
                          onTap: () {},
                        ),
                        SizedBox(width: 12.sp),
                        CallActionButton(
                          icon: PhosphorIcons.camera_slash_bold,
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.sp),
              StackAvatar(
                images: const [
                  'https://avatars.githubusercontent.com/u/60530946?v=4',
                  'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                ],
                size: 32.sp,
              ),
              SizedBox(height: 16.sp),
              Text(
                "🚀 QA engineers Team - Waterbus.io with high-quality app",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeCard(
                    text: "Meet at 19:30",
                    iconData: PhosphorIcons.clock,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(.2),
                  ),
                  SizedBox(width: 4.sp),
                  TimeCard(
                    text: "05/04/2023",
                    iconData: PhosphorIcons.calendar,
                    backgroundColor: Colors.greenAccent.withOpacity(.25),
                  ),
                  SizedBox(width: 4.sp),
                  const TimeCard(
                    text: "Share",
                    iconData: PhosphorIcons.export,
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 8.sp),
              GestureWrapper(
                onTap: () {
                  AppNavigator.pop();
                  AppNavigator.push(Routes.meetingRoute);
                },
                child: Container(
                  width: 80.sp,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 4.sp),
                      Text(
                        "Start",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 9.sp,
                            ),
                      ),
                      SizedBox(width: 4.sp),
                      Icon(
                        PhosphorIcons.arrow_right_bold,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.sp),
            ],
          ),
        ),
      ],
    );
  }
}
