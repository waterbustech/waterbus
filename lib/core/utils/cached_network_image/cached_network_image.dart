// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waterbus/core/utils/cached_network_image/default_image.dart';
import 'package:waterbus/core/utils/cached_network_image/place_holder.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? urlToImage;
  final double? height;
  final double? width;
  final BoxShape shape;
  final BoxFit? fit;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final Widget? placeHolderWidget;
  final ColorFilter? colorFilter;
  final Widget? childInAvatar;
  final List<BoxShadow>? boxShadow;
  // ignore: use_key_in_widget_constructors
  const CustomNetworkImage({
    Key? key,
    required this.urlToImage,
    this.height,
    this.width,
    this.shape = BoxShape.circle,
    this.fit = BoxFit.cover,
    this.margin,
    this.borderRadius,
    this.placeHolderWidget,
    this.colorFilter,
    this.childInAvatar,
    this.border,
    this.boxShadow,
  }) : assert(height != null || width != null);
  @override
  Widget build(BuildContext context) {
    return urlToImage == null || urlToImage!.isEmpty
        ? placeHolderWidget ?? _defaultImage
        : CachedNetworkImage(
            cacheKey: urlToImage,
            memCacheHeight: 1024 * 200,
            memCacheWidth: 1024 * 200,
            maxWidthDiskCache: 1024 * 1024,
            maxHeightDiskCache: 1024 * 1024,
            imageUrl: urlToImage!,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: height ?? width!,
                width: width ?? height!,
                margin: margin,
                decoration: BoxDecoration(
                  shape: shape,
                  border: border,
                  borderRadius: borderRadius,
                  image: DecorationImage(
                    colorFilter: colorFilter,
                    image: imageProvider,
                    fit: fit,
                  ),
                  boxShadow: boxShadow,
                ),
                alignment: Alignment.bottomRight,
                child: childInAvatar,
              );
            },
            placeholder: (context, url) => placeHolderWidget ?? _placeHolder,
            errorWidget: (context, url, error) =>
                placeHolderWidget ?? _defaultImage,
          );
  }

  Widget get _defaultImage => DefaultImage(
        height: height ?? width!,
        width: width ?? height!,
        margin: margin,
        shape: shape,
        borderRadius: borderRadius,
        childInAvatar: childInAvatar,
      );

  Widget get _placeHolder => Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: PlaceHolder(
            shape: shape,
            height: height,
            width: width,
          ),
        ),
      );
}
