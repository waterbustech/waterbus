import 'package:flutter/material.dart';

import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';

class AvatarChat extends StatelessWidget {
  final Room room;
  final double size;
  final BoxShape shape;
  const AvatarChat({
    super.key,
    required this.room,
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
        urlToImage: room.avatar,
        defaultAvatar: DefaultAvatarModel.fromFullName(room.title),
        shape: shape,
      ),
    );
  }
}
