// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/chats/xmodels/chat_model.dart';

class AvatarChat extends StatelessWidget {
  final ChatModel chatModel;
  final double size;
  const AvatarChat({
    super.key,
    required this.chatModel,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return chatModel.isGroup ? groupChat() : singleChat();
  }

  Widget singleChat() {
    return Container(
      padding: EdgeInsets.all(2.5.sp),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mGD,
      ),
      child: CustomNetworkImage(
        height: size,
        width: size,
        urlToImage: chatModel.urlImage.first,
      ),
    );
  }

  Widget groupChat() {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(1.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mGD,
              ),
              child: CustomNetworkImage(
                height: size * 0.7,
                width: size * 0.7,
                urlToImage: chatModel.urlImage.first,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(1.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mCL,
              ),
              child: CustomNetworkImage(
                height: size * 0.7,
                width: size * 0.7,
                urlToImage: chatModel.urlImage[1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
