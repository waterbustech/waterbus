import 'package:flutter/material.dart';
import 'package:waterbus/core/constants/constants.dart';

import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class AvatarCard extends StatelessWidget {
  final String? urlToImage;
  final double size;
  final EdgeInsetsGeometry? margin;
  final bool isCircleShape;
  const AvatarCard({
    super.key,
    required this.urlToImage,
    required this.size,
    this.margin,
    this.isCircleShape = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      margin: margin,
      width: size,
      urlToImage: urlToImage ?? kUserDefault.avatar,
    );
  }
}
