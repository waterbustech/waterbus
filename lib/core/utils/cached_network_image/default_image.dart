import 'package:flutter/material.dart';
import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';
import 'package:waterbus/gen/assets.gen.dart';

class DefaultImage extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final Widget? childInAvatar;
  final DefaultAvatarModel? defaultAvatar;
  final BoxBorder? border;
  const DefaultImage({
    super.key,
    required this.height,
    required this.width,
    this.margin,
    required this.shape,
    this.borderRadius,
    this.childInAvatar,
    this.defaultAvatar,
    this.border,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: Container(
              height: height,
              width: width,
              decoration: defaultAvatar != null
                  ? BoxDecoration(
                      color: defaultAvatar!.backgroundColor,
                      shape: shape,
                      border: border,
                    )
                  : BoxDecoration(
                      shape: shape,
                      border: border,
                      borderRadius: borderRadius,
                      image: DecorationImage(
                        image: AssetImage(Assets.images.imgLogo.path),
                        fit: shape == BoxShape.circle
                            ? BoxFit.fitHeight
                            : BoxFit.contain,
                      ),
                    ),
              alignment: Alignment.bottomRight,
              child: childInAvatar,
            ),
          ),
          defaultAvatar == null
              ? const SizedBox()
              : Text(
                  defaultAvatar!.keyword,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 2.85,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}
