// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/gen/assets.gen.dart';

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
    return urlToImage == null || urlToImage!.isEmpty
        ? Container(
            margin: margin,
            child: Material(
              shape: isCircleShape
                  ? CircleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(.5),
                        width: .5,
                      ),
                    )
                  : SuperellipseShape(
                      borderRadius: BorderRadius.circular(size * 0.55),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(.5),
                        width: .5,
                      ),
                    ),
              child: Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(size * 0.12),
                alignment: Alignment.center,
                child: Image.asset(
                  Assets.images.imgAppLogo.path,
                  width: size,
                  height: size,
                ),
              ),
            ),
          )
        : CustomNetworkImage(
            margin: margin,
            width: size,
            urlToImage: urlToImage,
          );
  }
}
