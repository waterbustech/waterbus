import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class StackAvatar extends StatelessWidget {
  final List<String?> images;
  final double size;
  final int maxImages;
  const StackAvatar({
    super.key,
    required this.images,
    this.size = 25,
    this.maxImages = 5,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ...images
            .sublist(0, min(maxImages, images.length))
            .asMap()
            .map((index, img) => MapEntry(index, _buildAvatar(context, index)))
            .values,
        images.length > maxImages
            ? Container(
                height: size,
                width: size,
                margin: EdgeInsets.only(left: maxImages * (size * 0.8)),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "+${images.length - maxImages}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 8.sp,
                      ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildAvatar(context, index) {
    return AvatarCard(
      size: size,
      margin: EdgeInsets.only(left: index * (size * 0.8)),
      urlToImage: images[index],
      isCircleShape: true,
    );
  }
}
