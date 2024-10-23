import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/list_custom/pagination_list_view.dart';
import 'package:waterbus/core/utils/shimmers/shimmer_list.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/bloc/archived_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  void initState() {
    super.initState();

    AppBloc.archivedBloc.add(OnArchivedEvent());
  }

  void _handleTapArchivedItem(Meeting meeting) {
    AppNavigator().push(
      Routes.archivedConversationRoute,
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
              title: Strings.archivedChats.i18n,
              leading: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserGetDone) {
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
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.sp),
          SizerUtil.isDesktop
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  child: Text(
                    Strings.archivedChats.i18n,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 15.sp,
                        ),
                  ),
                )
              : EnterCodeBox(
                  hintTextContent: Strings.search.i18n,
                  onTap: () {},
                ),
          Expanded(
            child: BlocBuilder<ArchivedBloc, ArchivedState>(
              builder: (context, state) {
                if (state is ArchivedInitial) {
                  return const ShimmerList(child: ShimmerChatCard());
                }

                final List<Meeting> meetings = [];

                if (state is ActiveArchivedState) {
                  meetings.addAll(state.archivedConversations);
                }

                return meetings.isEmpty
                    ? const SizedBox()
                    : PaginationListView(
                        itemCount: meetings.length,
                        shrinkWrap: true,
                        callBackRefresh: (handleFinish) {
                          AppBloc.archivedBloc.add(
                            RefreshArchivedEvent(
                              handleFinish: handleFinish,
                            ),
                          );
                        },
                        callBackLoadMore: () {
                          AppBloc.archivedBloc.add(GetMoreArchivedEvent());
                        },
                        isLoadMore: state is GettingArchivedState,
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
                              _handleTapArchivedItem(meetings[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ChatCard(meeting: meetings[index]),
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
      ),
    );
  }
}
