import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';

class ConversationScreen extends StatefulWidget {
  final Meeting meeting;
  const ConversationScreen({super.key, required this.meeting});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  void initState() {
    super.initState();
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));
  }

  @override
  void didUpdateWidget(covariant ConversationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: SizerUtil.isDesktop,
        child: Column(
          children: [
            SizedBox(height: 5.sp),
            ConversationHeader(meeting: widget.meeting),
            SizedBox(height: 5.sp),
            divider,
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is GettingMessageState) return const Spacer();

                if (state is GetDoneMessageState) {
                  final List<MessageModel> messages = state.messages;

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messages.length,
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureWrapper(
                          onLongPress: () {
                            if (!messages[index].isMe) return;

                            HapticFeedback.lightImpact();

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black38,
                              enableDrag: false,
                              builder: (context) {
                                return BottomChatOptions(
                                  options: messages[index].getOptions,
                                );
                              },
                            );
                          },
                          child: MessageCard(
                            message: messages[index],
                            messagePrev: index < messages.length - 1
                                ? messages[index + 1]
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Spacer();
              },
            ),
            InputSendMessage(meetingId: widget.meeting.id),
            SizedBox(height: WebRTC.platformIsMobile ? 10.sp : 0),
          ],
        ),
      ),
    );
  }
}
