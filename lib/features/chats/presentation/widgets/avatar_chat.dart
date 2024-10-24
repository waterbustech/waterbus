import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';

class AvatarChat extends StatelessWidget {
  final Meeting meeting;
  final double size;
  final BoxShape shape;
  const AvatarChat({
    super.key,
    required this.meeting,
    this.shape = BoxShape.rectangle,
    this.size = 42.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: shape == BoxShape.circle
          ? const CircleBorder()
          : SuperellipseShape(
              borderRadius: BorderRadius.circular(20.sp),
            ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomNetworkImage(
        height: size,
        width: size,
        urlToImage: meeting.avatar,
        defaultAvatar: DefaultAvatarModel.fromFullName(meeting.title),
        shape: shape,
      ),
    );
  }
}
