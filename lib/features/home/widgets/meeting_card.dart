// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/home/widgets/dialog_prepare_meeting.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/home/widgets/time_card.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.sp),
      padding: EdgeInsets.symmetric(
        vertical: 14.sp,
        horizontal: 16.sp,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0d0d0d),
        borderRadius: BorderRadius.circular(14.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🚀 QA engineers Team - Waterbus.io with high-quality app",
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Row(
            children: [
              TimeCard(
                text: "Meet at 19:30",
                iconData: PhosphorIcons.clock,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
              ),
              SizedBox(width: 4.sp),
              TimeCard(
                text: "05/04/2023",
                iconData: PhosphorIcons.calendar,
                backgroundColor: Colors.greenAccent.withOpacity(.25),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: StackAvatar(
                  images: const [
                    'https://avatars.githubusercontent.com/u/60530946?v=4',
                    'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  ],
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialogWaterbus(
                    alignment: Alignment.bottomCenter,
                    paddingBottom: 56.sp,
                    child: const DialogPrepareMeeting(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 4.sp),
                      Text(
                        "Join",
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
            ],
          ),
        ],
      ),
    );
  }
}
