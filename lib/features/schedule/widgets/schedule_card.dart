// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.sp,
      ),
      decoration: BoxDecoration(
        color: colorBlack1,
        border: Border(
          top: BorderSide(
            color: colorPrimary,
            width: 1.5.sp,
          ),
          bottom: BorderSide(
            color: fCD,
            width: 0.5.sp,
          ),
          left: BorderSide(
            color: fCD,
            width: 0.5.sp,
          ),
          right: BorderSide(
            color: fCD,
            width: 0.5.sp,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 7.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meeting with Hans',
            style: TextStyle(
              color: mCL,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    PhosphorIcons.clock_light,
                    color: fCL,
                    size: 12.sp,
                  ),
                  SizedBox(width: 5.sp),
                  Text(
                    '9:00 AM - 9:35 AM',
                    style: TextStyle(
                      color: fCL,
                      fontSize: 11.sp,
                    ),
                  )
                ],
              ),
              StackAvatar(
                images: const [
                  'https://avatars.githubusercontent.com/u/60530946?v=4',
                  'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                ],
                size: 17.sp,
                maxImages: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
