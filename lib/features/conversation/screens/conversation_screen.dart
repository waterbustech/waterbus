import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/shimmers/fade_shimmer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';

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
                if (state is MessageInitial) {
                  return const ListConversationShimmers();
                }

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

class ListConversationShimmers extends StatelessWidget {
  const ListConversationShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    bool isMe = random.nextBool();

    return ListView.builder(
      padding: EdgeInsets.only(top: 30.sp),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      itemCount: 20,
      itemBuilder: (context, index) {
        final int numberOfRow = random.nextInt(2) + 1;
        isMe = !isMe;

        return MessageShimmerCard(isMe: isMe, numberOfRow: numberOfRow);
      },
    );
  }
}

class MessageShimmerCard extends StatelessWidget {
  final bool isMe;
  final int numberOfRow;

  const MessageShimmerCard({
    super.key,
    required this.isMe,
    this.numberOfRow = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        SizedBox(width: 10.sp),
        !isMe
            ? FadeShimmer.round(
                size: 20.sp,
                fadeTheme: FadeTheme.lightReverse,
              )
            : SizedBox(height: 20.sp, width: 20.sp),
        Container(
          margin: EdgeInsets.only(
            right: 12.sp,
            left: 8.sp,
            bottom: 16.sp,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          constraints: BoxConstraints(
            maxWidth: 195.sp,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeShimmer(
                width: 100.w,
                height: 12.sp,
                fadeTheme: FadeTheme.lightReverse,
              ),
              numberOfRow == 2 ? SizedBox(height: 8.sp) : Container(),
              numberOfRow == 2
                  ? FadeShimmer(
                      width: 35.w,
                      height: 12.sp,
                      fadeTheme: FadeTheme.lightReverse,
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
