import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/paginated_list_view.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/bloc/archived_bloc.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_conversation_screen.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/shimmers/shimmer_list.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  Room? _room;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    AppBloc.archivedBloc.add(ArchivedStarted());
  }

  void _handleTapArchivedItem(Room room) {
    if (PlatformUtils.isDesktop) {
      setState(() {
        _room = room;
        _currentIndex = 1;
      });
    } else {
      ArchivedConversationRoute($extra: room).push(context);
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
        _bodyArchivedScreen(context),
        ArchivedConversationScreen(
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

  Scaffold _bodyArchivedScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: context.isDesktop
          ? null
          : appBarTitleBack(
              context,
              title: Strings.archivedChats.i18n,
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.sp),
          context.isDesktop
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

                final List<Room> rooms = [];

                if (state is ArchivedActived) {
                  rooms.addAll(state.archivedConversations);
                }

                return rooms.isEmpty
                    ? const SizedBox()
                    : PaginatedListView(
                        itemCount: rooms.length,
                        shrinkWrap: true,
                        callBackRefresh: (handleFinish) {
                          AppBloc.archivedBloc.add(
                            ArchivedRefreshed(
                              handleFinish: handleFinish,
                            ),
                          );
                        },
                        callBackLoadMore: () {
                          AppBloc.archivedBloc.add(ArchivedDataFetched());
                        },
                        isLoadMore: state is ArchivedInProgress,
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
                              _handleTapArchivedItem(rooms[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ChatCard(room: rooms[index]),
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
