import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/message_list.dart';

class ChatInMeeting extends StatefulWidget {
  final Meeting meeting;
  final Function onClosePressed;
  const ChatInMeeting({
    super.key,
    required this.meeting,
    required this.onClosePressed,
  });

  @override
  State<ChatInMeeting> createState() => _ChatInMeetingState();
}

class _ChatInMeetingState extends State<ChatInMeeting> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    AppBloc.messageBloc.add(
      GetMessageByMeetingIdEvent(meetingId: widget.meeting.id),
    );

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
  void didUpdateWidget(ChatInMeeting oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppBloc.messageBloc.add(
      GetMessageByMeetingIdEvent(meetingId: widget.meeting.id),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.sp),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12.sp),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Container(
          padding: EdgeInsets.only(
            left: 14.sp,
            right: 4.sp,
            top: 16.sp,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onClosePressed();
                    },
                    iconSize: 18.sp,
                    icon: Icon(PhosphorIcons.x()),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessageInitial) {
                      return const SizedBox();
                    }

                    if (state is ActiveMessageState) {
                      final List<MessageModel> messages = state.messages;
                      return MessageList(
                        messages: messages,
                        scrollController: _scrollController,
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              InputSendMessage(meetingId: widget.meeting.id),
            ],
          ),
        ),
      ),
    );
  }
}
