import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/paginated_list_view.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/conversation_label.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/shimmers/shimmer_list.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';

class ConversationList extends StatelessWidget {
  final Function(int) onTap;

  const ConversationList({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.sp),
        context.isDesktop
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

              final List<Room> rooms = [];

              if (state is ChatActived) {
                rooms.addAll(state.conversations);
              }

              return rooms.isEmpty
                  ? const SizedBox()
                  : PaginatedListView(
                      itemCount: rooms.length,
                      shrinkWrap: true,
                      callBackRefresh: (handleFinish) {
                        AppBloc.chatBloc.add(
                          ChatRefreshed(handleFinish: handleFinish),
                        );
                      },
                      callBackLoadMore: () {
                        AppBloc.chatBloc.add(ChatFetched());
                      },
                      isLoadMore: state is ChatInProgress,
                      padding: EdgeInsets.only(
                        bottom: context.isDesktop ? 25.sp : 70.sp,
                        top: 8.sp,
                      ),
                      itemBuilder: (context, index) {
                        if (index > rooms.length - 1) {
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
                                  return _menuProvider(rooms[index]);
                                },
                                liftBuilder: (context, child) {
                                  return ChatCard(
                                    room: rooms[index],
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.sp,
                                      vertical: 8.sp,
                                    ),
                                  );
                                },
                                child: ChatCard(room: rooms[index]),
                              ),
                              if (index < rooms.length - 1)
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

  Menu _menuProvider(Room conversation) {
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
