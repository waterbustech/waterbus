// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/conversation/models/message_model.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5.sp),
            const ConversationHeader(),
            SizedBox(height: 5.sp),
            divider,
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listMessageFake.length,
                padding: EdgeInsets.symmetric(vertical: 12.sp),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageCard(
                    messageModel: listMessageFake[index],
                    messageModelBefore: index == listMessageFake.length - 1
                        ? null
                        : listMessageFake[index + 1],
                  );
                },
              ),
            ),
            const InputSendMessage(),
          ],
        ),
      ),
    );
  }
}
