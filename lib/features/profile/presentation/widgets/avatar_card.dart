import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';

class AvatarCard extends StatelessWidget {
  final String? urlToImage;
  final double size;
  final EdgeInsetsGeometry? margin;
  final bool isCircleShape;
  final String? title;
  const AvatarCard({
    super.key,
    required this.urlToImage,
    required this.size,
    this.margin,
    this.title,
    this.isCircleShape = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      margin: margin,
      width: size,
      urlToImage: urlToImage ?? kUserDefault.avatar,
      defaultAvatar:
          title == null ? null : DefaultAvatarModel.fromFullName(title!),
    );
  }
}
