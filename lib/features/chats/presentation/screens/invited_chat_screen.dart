import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/invited_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus_sdk/types/index.dart';

class InvitedChatScreen extends StatefulWidget {
  const InvitedChatScreen({super.key});

  @override
  State<InvitedChatScreen> createState() => _InvitedChatScreenState();
}

class _InvitedChatScreenState extends State<InvitedChatScreen> {
  @override
  void initState() {
    super.initState();

    AppBloc.chatBloc.add(GetInvitedConversations());
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
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ActiveChatState) {
                  if (state is GettingInvitedChatState) return const SizedBox();

                  final List<Meeting> invitedConversations =
                      state.invitedConversations;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InvitedChatCard(
                        invitedConversation: invitedConversations[index],
                        index: index,
                      );
                    },
                    itemCount: invitedConversations.length,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
