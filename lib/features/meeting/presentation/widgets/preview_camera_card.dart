// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';

class PreviewCameraCard extends StatelessWidget {
  const PreviewCameraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        ),
      ],
    );
  }
}
