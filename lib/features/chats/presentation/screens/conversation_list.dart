import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/list_custom/pagination_list_view.dart';
import 'package:waterbus/core/utils/shimmers/shimmer_list.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/conversation_label.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';

class ConversationList extends StatelessWidget {
  final Function(int) onTap;

  const ConversationList({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.sp),
        SizerUtil.isDesktop
            ? const ConversationLabel()
            : EnterCodeBox(
                hintTextContent: Strings.search.i18n,
                onTap: () {},
              ),
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatInitial) {
                return const ShimmerList(child: ShimmerChatCard());
              }

              final List<Meeting> meetings = [];

              if (state is ActiveChatState) {
                meetings.addAll(state.conversations);
              }

              return meetings.isEmpty
                  ? const SizedBox()
                  : PaginationListView(
                      itemCount: meetings.length,
                      shrinkWrap: true,
                      callBackRefresh: (handleFinish) {
                        AppBloc.chatBloc.add(
                          RefreshConversationsEvent(handleFinish: handleFinish),
                        );
                      },
                      callBackLoadMore: () {
                        AppBloc.chatBloc.add(GetConversationsEvent());
                      },
                      isLoadMore: state is GettingChatState,
                      padding: EdgeInsets.only(
                        bottom: SizerUtil.isDesktop ? 25.sp : 70.sp,
                        top: 8.sp,
                      ),
                      itemBuilder: (context, index) {
                        if (index > meetings.length - 1) {
                          return const SizedBox();
                        }

                        return GestureWrapper(
                          onTap: () {
                            onTap.call(index);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContextMenuWidget(
                                menuProvider: (_) {
                                  return _menuProvider(meetings[index]);
                                },
                                child: ChatCard(meeting: meetings[index]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 58.sp),
                                child: divider,
                              ),
                            ],
                          ),
                        );
                      },
                      childShimmer: const ShimmerChatCard(),
                    );
            },
          ),
        ),
      ],
    );
  }

  Menu _menuProvider(Meeting conversation) {
    return Menu(
      children: List.generate(
        conversation.getOptions.length,
        (indexOptions) => MenuAction(
          image: MenuImage.icon(
            conversation.getOptions[indexOptions].iconData,
          ),
          attributes: MenuActionAttributes(
            destructive: conversation.getOptions[indexOptions].isDanger,
          ),
          title: conversation.getOptions[indexOptions].title,
          callback: () {
            conversation.getOptions[indexOptions].handlePressed?.call();
          },
        ),
      ),
    );
  }
}
