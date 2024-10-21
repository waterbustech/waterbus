import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/sending_status_enum.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/input_send_message.dart';
import 'package:waterbus/features/conversation/widgets/list_conversation_shimmers.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';
import 'package:waterbus/features/conversation/widgets/message_suggest_widget.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ConversationScreen extends StatefulWidget {
  final Meeting meeting;
  const ConversationScreen({super.key, required this.meeting});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  late String _image;

  @override
  void initState() {
    super.initState();
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));
    _image = _imageHelloMessage;
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
  void didUpdateWidget(ConversationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));
    _image = _imageHelloMessage;
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
            const ConversationHeader(),
            SizedBox(height: 5.sp),
            divider,
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageInitial) {
                    return const ListConversationShimmers();
                  }

                  if (state is ActiveMessageState) {
                    final List<MessageModel> messages = state.messages;

                    return messages.isEmpty
                        ? GestureWrapper(
                            onTap: () {
                              AppBloc.messageBloc.add(
                                SendMessageEvent(
                                  data: "${Strings.hi.i18n}!",
                                  meetingId: widget.meeting.id,
                                ),
                              );
                            },
                            child: MessageSuggestWidget(image: _image),
                          )
                        : CustomScrollView(
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
                                          if (messages[index].sendingStatus !=
                                                  SendingStatusEnum.sent ||
                                              messages[index].isDeleted) return;

                                          _handleLongPressMessageCard(
                                            messages[index],
                                          );
                                        },
                                        child: MessageCard(
                                          message: messages[index],
                                          messagePrev:
                                              index < messages.length - 1
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
                          );
                  }

                  return const SizedBox();
                },
              ),
            ),
            InputSendMessage(meetingId: widget.meeting.id),
            SizedBox(
              height: !SizerUtil.isDesktop &&
                      MediaQuery.of(context).viewInsets.bottom == 0
                  ? 10.sp
                  : 0.sp,
            ),
          ],
        ),
      ),
    );
  }

  String get _imageHelloMessage {
    final List<AssetGenImage> images = [
      Assets.images.imgHelloMessage1,
      Assets.images.imgHelloMessage2,
      Assets.images.imgHelloMessage3,
      Assets.images.imgHelloMessage4,
      Assets.images.imgHelloMessage5,
      Assets.images.imgHelloMessage6,
      Assets.images.imgHelloMessage7,
    ];

    return images[Random().nextInt(images.length)].path;
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
