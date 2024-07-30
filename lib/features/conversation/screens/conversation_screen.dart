import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus/features/conversation/widgets/list_conversation_shimmers.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';
import 'package:waterbus_sdk/types/models/message_status_enum.dart';

class ConversationScreen extends StatefulWidget {
  final Meeting meeting;
  const ConversationScreen({super.key, required this.meeting});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));

    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent > 0 &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 2.sp) {
          AppBloc.messageBloc.add(GetMoreMessageEvent());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  return const Expanded(child: ListConversationShimmers());
                }

                if (state is ActiveMessageState) {
                  final List<MessageModel> messages = state.messages;

                  return Expanded(
                    child: CustomScrollView(
                      semanticChildCount: messages.length,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          sliver: SuperSliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return GestureWrapper(
                                  onLongPress: () {
                                    if (messages[index].status !=
                                        MessageStatusEnum.sent) return;

                                    _handleLongPressMessageCard(
                                      messages[index],
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
                              childCount: messages.length,
                            ),
                          ),
                        ),
                      ],
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

  void _handleLongPressMessageCard(MessageModel messageModel) {
    if (!messageModel.isMe) return;

    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      enableDrag: false,
      builder: (context) {
        return BottomChatOptions(options: messageModel.getOptions);
      },
    );
  }
}
