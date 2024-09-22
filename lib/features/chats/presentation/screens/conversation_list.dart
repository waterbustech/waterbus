import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/list_custom/pagination_list_view.dart';
import 'package:waterbus/core/utils/shimmers/shimmer_list.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
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
        EnterCodeBox(
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
              Meeting? conversationCurrent;

              if (state is ActiveChatState) {
                meetings.addAll(state.conversations);
                conversationCurrent = state.conversationCurrent;
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

                        return Slidable(
                          key: ValueKey(meetings[index].id),
                          endActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const StretchMotion(),
                            dragDismissible: false,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  AppBloc.chatBloc.add(
                                    DeleteOrLeaveConversationEvent(
                                      meeting: meetings[index],
                                    ),
                                  );
                                },
                                backgroundColor: colorHigh,
                                foregroundColor: mCL,
                                icon: PhosphorIcons.trash,
                                label: Strings.delete.i18n,
                              ),
                            ],
                          ),
                          child: GestureWrapper(
                            onLongPress: () {
                              HapticFeedback.lightImpact();

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                barrierColor: Colors.black38,
                                enableDrag: false,
                                builder: (context) {
                                  return BottomChatOptions(
                                    options: meetings[index].getOptions,
                                  );
                                },
                              );
                            },
                            onTap: () {
                              onTap.call(index);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.sp,
                                    vertical: 4.sp,
                                  ),
                                  color: SizerUtil.isDesktop &&
                                          conversationCurrent == meetings[index]
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(.2)
                                      : Colors.transparent,
                                  child: ChatCard(meeting: meetings[index]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizerUtil.isDesktop ? 74.sp : 64.sp,
                                  ),
                                  child: divider,
                                ),
                              ],
                            ),
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
}
