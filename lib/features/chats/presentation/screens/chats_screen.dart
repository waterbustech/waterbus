import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/screens/conversation_list.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/room/presentation/screens/meeting_form_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Room? _room;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    if (AppRouter.context!.isMobile) {
      AppBloc.chatBloc.add(ChatStarted());
    }
  }

  void _handleTapChatItem(Room room) {
    if (context.isDesktop) {
      setState(() {
        _room = room;
        _currentIndex = 1;
      });
    } else {
      ConversationRoute($extra: room).push(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyAnimatedIndexedStack(
      index: _currentIndex,
      duration: kIsWeb ? Duration.zero : 200.milliseconds,
      animationBuilder: (context, animation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      children: [
        _bodyChatScreen(context),
        ConversationScreen(
          room: _room,
          onBackScreen: () {
            setState(() {
              _currentIndex = 0;
              _room = null;
            });
          },
        ),
      ],
    );
  }

  Scaffold _bodyChatScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: context.isDesktop
          ? null
          : appBarTitleBack(
              context,
              title: Strings.chat.i18n,
              leading: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserDone) {
                    final User user = state.user;

                    return Align(
                      alignment: Alignment.centerRight,
                      child: AvatarCard(
                        urlToImage: user.avatar,
                        size: 24.sp,
                        label: user.fullName,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              actions: [
                TooltipWrapper(
                  message: Strings.createRoom.i18n,
                  child: IconButton(
                    onPressed: () {
                      if (context.isMobile) {
                        NewRoomRoute(isChatScreen: true).push(context);
                      } else {
                        showScreenAsDialog(
                          route: Routes.updateRoomRoute,
                          child: MeetingFormScreen(isChatScreen: true),
                        );
                      }
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
          if (state is ChatActived) {
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
    );
  }
}
