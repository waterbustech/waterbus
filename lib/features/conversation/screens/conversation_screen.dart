import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/chats/xmodels/chat_model.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';
import 'package:waterbus/features/conversation/xmodels/message_model.dart';

class ConversationScreen extends StatelessWidget {
  final ChatModel chatModel;
  const ConversationScreen({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: SizerUtil.isDesktop,
        child: Column(
          children: [
            SizedBox(height: 5.sp),
            ConversationHeader(chatModel: chatModel),
            SizedBox(height: 5.sp),
            divider,
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: listMessageFake.length,
                padding: EdgeInsets.symmetric(vertical: 12.sp),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageCard(
                    message: listMessageFake[index],
                    messagePrev: index < listMessageFake.length - 1
                        ? listMessageFake[index + 1]
                        : null,
                  );
                },
              ),
            ),
            const InputSendMessage(),
            SizedBox(height: WebRTC.platformIsMobile ? 10.sp : 0),
          ],
        ),
      ),
    );
  }
}
