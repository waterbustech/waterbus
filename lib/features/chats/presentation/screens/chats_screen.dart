import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/screens/conversation_list.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/home/widgets/tab_options_desktop_widget.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();

    if (SizerUtil.isDesktop) {
      AppBloc.chatBloc.add(CleanConversationCurrentEvent());
    }
  }

  void _handleTapChatItem(Meeting meeting) {
    if (SizerUtil.isDesktop) {
      AppBloc.chatBloc.add(SelectConversationCurrentEvent(meeting: meeting));
    } else {
      AppNavigator().push(
        Routes.conversationRoute,
        arguments: {
          'meeting': meeting,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: SizerUtil.isDesktop ? 300.sp : 100.w,
          child: Scaffold(
            appBar: appBarTitleBack(
              context,
              title: Strings.chat.i18n,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      PhosphorIcons.plus,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            body: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ActiveChatState) {
                  return SizerUtil.isDesktop
                      ? TabOptionsDesktopWidget(
                          child: ConversationList(
                            onTap: (index) {
                              _handleTapChatItem(state.conversations[index]);
                            },
                          ),
                        )
                      : ConversationList(
                          onTap: (index) {
                            _handleTapChatItem(state.conversations[index]);
                          },
                        );
                }

                return const SizedBox();
              },
            ),
            floatingActionButton: Container(
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
                  PhosphorIcons.paper_plane_tilt_bold,
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        if (SizerUtil.isDesktop)
          const VerticalDivider(
            width: .5,
            thickness: .5,
          ),
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is GetDoneChatState) {
              return Expanded(
                child: state.conversationCurrent != null
                    ? ConversationScreen(meeting: state.conversationCurrent!)
                    : Image.asset(
                        Assets.images.imgAppLogo.path,
                        width: 200.sp,
                        height: 200.sp,
                      ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
