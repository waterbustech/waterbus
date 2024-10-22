import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';
import 'package:waterbus_sdk/types/models/message_model.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/widgets/list_conversation_shimmers.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';

class ArchivedConversationScreen extends StatefulWidget {
  final Meeting meeting;
  const ArchivedConversationScreen({super.key, required this.meeting});

  @override
  State<ArchivedConversationScreen> createState() =>
      _ArchivedConversationScreenState();
}

class _ArchivedConversationScreenState
    extends State<ArchivedConversationScreen> {
  final ScrollController _scrollController = ScrollController();

  Meeting get meeting => widget.meeting;

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
  void didUpdateWidget(ArchivedConversationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppBloc.messageBloc
        .add(GetMessageByMeetingIdEvent(meetingId: widget.meeting.id));
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Row(
                children: [
                  Visibility(
                    visible: AppNavigator.canPop,
                    child: GestureWrapper(
                      onTap: () {
                        AppNavigator.pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 12.sp).add(
                          EdgeInsets.only(right: 10.sp),
                        ),
                        child: Icon(
                          PhosphorIcons.caretLeft(PhosphorIconsStyle.light),
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarChat(meeting: meeting, size: 30.sp),
                          SizedBox(width: 10.sp),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  meeting.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  "${meeting.members.length} ${(meeting.members.length < 2 ? Strings.member.i18n : Strings.members.i18n).toLowerCase()}",
                                  style: TextStyle(
                                    color: fCL,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

                    return CustomScrollView(
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
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
            // InputSendMessage(meetingId: widget.meeting.id),
            divider,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
              child: Text(
                Strings.descriptionArchivedConversation.i18n,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: fCD,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
