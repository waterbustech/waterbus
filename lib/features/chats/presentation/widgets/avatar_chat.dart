import 'package:flutter/material.dart';

import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class AvatarChat extends StatelessWidget {
  final Meeting meeting;
  final double size;
  const AvatarChat({
    super.key,
    required this.meeting,
    this.size = 42.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: CustomNetworkImage(
        height: size,
        width: size,
        urlToImage: meeting.avatar,
        defaultAvatar: DefaultAvatarModel.fromFullName(meeting.title),
      ),
    );
  }
}
