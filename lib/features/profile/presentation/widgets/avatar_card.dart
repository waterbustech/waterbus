import 'package:flutter/material.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class AvatarCard extends StatelessWidget {
  final String urlToImage;
  final double size;
  const AvatarCard({
    super.key,
    required this.urlToImage,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      width: size,
      urlToImage: urlToImage,
    );
  }
}
