// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/home/widgets/stack_avatar.dart';

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
            "Research Plan for WebRTC conference meeting app 🌱",
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 4.sp),
          Text(
            "10:00 AM - 11:00 AM",
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10.sp,
                ),
          ),
          SizedBox(height: 4.sp),
          Text(
            "Host: lambiengcode",
            maxLines: 1,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 10.sp,
                ),
          ),
          SizedBox(height: 4.sp),
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
                  size: 24.sp,
                  maxImages: 5,
                ),
              ),
              Container(
                height: 34.sp,
                width: 34.sp,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: Icon(
                  PhosphorIcons.x,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.sp),
              Container(
                height: 34.sp,
                width: 34.sp,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(
                  PhosphorIcons.check,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
