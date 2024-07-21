import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/list_custom/pagination_list_view.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/invited_chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/invited_chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_invited_chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_invited_chat_list.dart';
import 'package:waterbus/features/common/styles/style.dart';

class InvitedChatScreen extends StatefulWidget {
  const InvitedChatScreen({super.key});

  @override
  State<InvitedChatScreen> createState() => _InvitedChatScreenState();
}

class _InvitedChatScreenState extends State<InvitedChatScreen> {
  @override
  void initState() {
    super.initState();

    AppBloc.invitedChatBloc.add(OnInvitedConversationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.invitedChat.i18n,
      ),
      body: Column(
        children: [
          divider,
          Expanded(
            child: BlocBuilder<InvitedChatBloc, InvitedChatState>(
              builder: (context, state) {
                if (state is ActiveInvitedChatState) {
                  final List<Meeting> invitedConversations =
                      state.invitedConversations;

                  return PaginationListView(
                    padding: EdgeInsets.only(bottom: 24.sp),
                    itemCount: invitedConversations.length,
                    shrinkWrap: true,
                    callBackRefresh: (handleFinish) =>
                        AppBloc.invitedChatBloc.add(
                      RefreshInvitedConversationsEvent(
                        handleFinish: handleFinish,
                      ),
                    ),
                    callBackLoadMore: () => AppBloc.invitedChatBloc
                        .add(GetInvitedConversationsEvent()),
                    isLoadMore: state is GettingInvitedChatState,
                    itemBuilder: (context, index) => InvitedChatCard(
                      invitedConversation: invitedConversations[index],
                      index: index,
                    ),
                    childShimmer: const ShimmerInvitedChatCard(),
                  );
                }

                return const ShimmerInvitedChatList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
