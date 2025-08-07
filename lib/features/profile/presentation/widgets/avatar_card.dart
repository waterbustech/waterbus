import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/domain/entities/default_avatar_model.dart';

class AvatarCard extends StatelessWidget {
  final String? urlToImage;
  final double size;
  final EdgeInsetsGeometry? margin;
  final bool isCircleShape;
  final String? label;
  const AvatarCard({
    super.key,
    required this.urlToImage,
    required this.size,
    this.margin,
    this.label,
    this.isCircleShape = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      margin: margin,
      width: size,
      borderRadius: isCircleShape ? null : BorderRadius.circular(2.sp),
      urlToImage: urlToImage ?? kUserDefault.avatar,
      shape: isCircleShape ? BoxShape.circle : BoxShape.rectangle,
      defaultAvatar:
          label == null ? null : DefaultAvatarModel.fromFullName(label!),
    );
  }
}
