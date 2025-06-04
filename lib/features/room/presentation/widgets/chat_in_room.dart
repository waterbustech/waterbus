import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/message_input_container.dart';
import 'package:waterbus/features/conversation/widgets/message_list.dart';

class ChatInRoom extends StatefulWidget {
  final Room room;
  final Function onClosePressed;
  const ChatInRoom({
    super.key,
    required this.room,
    required this.onClosePressed,
  });

  @override
  State<ChatInRoom> createState() => _ChatInRoomState();
}

class _ChatInRoomState extends State<ChatInRoom> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    AppBloc.messageBloc.add(
      MessageFetchedByMeeting(roomId: widget.room.id),
    );

    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent > 0 &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 2.sp) {
          AppBloc.messageBloc.add(MessageFetched());
        }
      },
    );
  }

  @override
  void didUpdateWidget(ChatInRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppBloc.messageBloc.add(
      MessageFetchedByMeeting(roomId: widget.room.id),
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
      padding:
          context.isDesktop ? EdgeInsets.only(right: 16.sp) : EdgeInsets.zero,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chats",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureWrapper(
                      onTap: () {
                        widget.onClosePressed();
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 18.sp,
                        width: 18.sp,
                        child: Icon(
                          PhosphorIcons.x(),
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessageInitial) {
                      return const SizedBox();
                    }

                    if (state is MessageActived) {
                      final List<Message> messages = state.messages;
                      return MessageList(
                        messages: messages,
                        scrollController: _scrollController,
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              MessageInputContainer(
                roomId: widget.room.id,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                isBorderVisible: false,
                borderRadius: BorderRadius.circular(12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
