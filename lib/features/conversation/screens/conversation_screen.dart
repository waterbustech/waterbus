import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/conversation_header.dart';
import 'package:waterbus/features/conversation/widgets/list_conversation_shimmers.dart';
import 'package:waterbus/features/conversation/widgets/message_input_container.dart';
import 'package:waterbus/features/conversation/widgets/message_list.dart';
import 'package:waterbus/features/conversation/widgets/message_suggest_widget.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ConversationScreen extends StatefulWidget {
  final Room? room;
  final Function()? onBackScreen;
  const ConversationScreen({super.key, this.room, this.onBackScreen});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  late String _image;

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      AppBloc.messageBloc.add(
        MessageFetchedByMeeting(roomId: widget.room!.id),
      );
    }

    _image = _imageHelloMessage;
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
  void didUpdateWidget(ConversationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.room != null) {
      AppBloc.messageBloc.add(MessageFetchedByMeeting(roomId: widget.room!.id));
    }

    _image = _imageHelloMessage;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) return SizedBox();

    return Scaffold(
      body: SafeArea(
        bottom: context.isDesktop,
        child: Column(
          children: [
            SizedBox(height: 5.sp),
            ConversationHeader(onBackScreen: widget.onBackScreen),
            SizedBox(height: 5.sp),
            divider,
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageInitial) {
                    return const ListConversationShimmers();
                  }

                  if (state is MessageActived) {
                    final List<Message> messages = state.messages;

                    return messages.isEmpty
                        ? GestureWrapper(
                            onTap: () {
                              AppBloc.messageBloc.add(
                                MessageSent(
                                  data: "${Strings.hi.i18n}!",
                                  roomId: widget.room!.id,
                                ),
                              );
                            },
                            child: MessageSuggestWidget(image: _image),
                          )
                        : MessageList(
                            messages: messages,
                            scrollController: _scrollController,
                          );
                  }

                  return const SizedBox();
                },
              ),
            ),
            MessageInputContainer(roomId: widget.room!.id),
            SizedBox(
              height: context.isMobile &&
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
}
