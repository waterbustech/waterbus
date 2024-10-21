import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/screens/conversation_list.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();

    AppBloc.chatBloc.add(OnChatEvent());
  }

  void _handleTapChatItem(Meeting meeting) {
    AppNavigator().push(
      Routes.conversationRoute,
      arguments: {
        'meeting': meeting,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SizerUtil.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: SizerUtil.isDesktop
          ? null
          : appBarTitleBack(
              context,
              title: Strings.chat.i18n,
              leading: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserGetDone) {
                    final User user = state.user;

                    return Align(
                      alignment: Alignment.centerRight,
                      child: AvatarCard(
                        urlToImage: user.avatar,
                        size: 24.sp,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              actions: [
                Tooltip(
                  message: Strings.createRoom.i18n,
                  child: IconButton(
                    onPressed: () {
                      AppNavigator().push(
                        Routes.createMeetingRoute,
                        arguments: {
                          'isChatScreen': true,
                        },
                      );
                    },
                    icon: Icon(
                      PhosphorIcons.plus(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ActiveChatState) {
            return ConversationList(
              onTap: (index) {
                if (index > state.conversations.length - 1) return;

                _handleTapChatItem(state.conversations[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: SizerUtil.isDesktop
          ? null
          : Container(
              margin:
                  EdgeInsets.only(bottom: SizerUtil.isDesktop ? 50.sp : 75.sp),
              height: 42.sp,
              width: 42.sp,
              child: FloatingActionButton(
                onPressed: () {
                  AppNavigator().push(Routes.invitedRoute);
                },
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                child: Icon(
                  PhosphorIcons.paperPlaneTilt(),
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
    );
  }
}
