// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/home/widgets/time_card.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({super.key});

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
            "🌸 Development Team 🌱",
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TimeCard(
                text: "Starting at 10:30",
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
              ),
              SizedBox(width: 4.sp),
              const TimeCard(
                text: "05/06/2023",
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: StackAvatar(
                  images: const [
                    'https://avatars.githubusercontent.com/u/60530946?v=4',
                    'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                    'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                  ],
                  size: 22.sp,
                  maxImages: 3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.sp,
                  vertical: 6.5.sp,
                ),
                width: 66.sp,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                child: Text(
                  "Reject",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 9.sp,
                      ),
                ),
              ),
              SizedBox(width: 4.sp),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 6.5.sp,
                ),
                width: 66.sp,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                child: Text(
                  "Accept",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 9.sp,
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
