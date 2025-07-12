import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_bottom_sheet.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';
import 'package:waterbus/features/conversation/widgets/detail_group_button.dart';
import 'package:waterbus/features/conversation/widgets/group_space_bar_custom.dart';
import 'package:waterbus/features/conversation/widgets/member_card.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/screens/meeting_form_screen.dart';

class DetailGroupScreen extends StatelessWidget {
  const DetailGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 155.sp,
            actions: [
              if (AppBloc.chatBloc.conversationCurrent?.isHost ?? false)
                TooltipWrapper(
                  message: Strings.editMeeting.i18n,
                  child: GestureWrapper(
                    onTap: () {
                      if (context.isMobile) {
                        UpdateRoomRoute(isChatScreen: true).push(context);
                      } else {
                        showScreenAsDialog(
                          route: Routes.updateRoomRoute,
                          child: MeetingFormScreen(
                            isChatScreen: true,
                            isEdit: true,
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        right: context.isDesktop ? 24.sp : 16.sp,
                      ),
                      child: Text(
                        Strings.edit.i18n,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
            leading: GestureWrapper(
              onTap: () {
                AppRouter.pop();
              },
              child: TooltipWrapper(
                message: Strings.back.i18n,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 3.sp),
                  child: Icon(
                    PhosphorIcons.caretLeft(PhosphorIconsStyle.light),
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            flexibleSpace: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatActived) {
                  final Room? room = state.conversationCurrent;

                  return room == null
                      ? const SizedBox()
                      : GroupSpaceBarCustom(
                          avatar: GestureWrapper(
                            onTap: () async {
                              await WaterbusImagePicker().openImagePicker(
                                context: context,
                                handleFinish: (image) async {
                                  AppBloc.chatBloc.add(
                                    ChatAvatarUpdated(
                                      avatar: image,
                                    ),
                                  );
                                },
                              );
                            },
                            child: AvatarChat(
                              room: room,
                              size: 54.sp,
                              shape: BoxShape.circle,
                            ),
                          ),
                          subTitle: Text(
                            "${room.members.length} ${(room.members.length < 2 ? Strings.member.i18n : Strings.members.i18n).toLowerCase()}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10.sp, color: fCL),
                          ),
                          title: Text(
                            room.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        );
                }
                return const SizedBox();
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.sp),
                  height: 48.sp,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailGroupButton(
                          onTap: () {
                            if (AppBloc.chatBloc.conversationCurrent == null) {
                              return;
                            }

                            AppBloc.roomBloc.add(
                              RoomJoinedEvent(
                                room: AppBloc.chatBloc.conversationCurrent!,
                                isMember: true,
                              ),
                            );
                          },
                          icon: PhosphorIcons.videoCamera(
                            PhosphorIconsStyle.fill,
                          ),
                          title: Strings.videoCall.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.bellRinging(
                            PhosphorIconsStyle.fill,
                          ),
                          title: Strings.mute.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.magnifyingGlass(
                            PhosphorIconsStyle.fill,
                          ),
                          title: Strings.search.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.dotsThreeOutline(),
                          title: Strings.more.i18n,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 30.sp),
            sliver: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatActived) {
                  if (state.conversationCurrent == null) {
                    return const SliverToBoxAdapter();
                  }

                  final Room conversation = state.conversations
                          .firstWhereOrNull(
                        (conversation) =>
                            conversation.id == state.conversationCurrent?.id,
                      ) ??
                      state.conversationCurrent!;

                  final List<Member> members =
                      conversation.members.map((member) => member).toList();

                  members.sort(
                    (a, b) => a.user.id == state.conversationCurrent!.host?.id
                        ? -1
                        : 1,
                  );

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bool isHost = index >= 0 &&
                            conversation.host?.id == members[index].user.id;

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.sp),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                index == 0 ? 12.sp : 0,
                              ),
                              bottom: Radius.circular(
                                index == members.length - 1 ? 12.sp : 0,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                index == members.length - 1 ? 12.sp : 0,
                              ),
                            ),
                            child: Slidable(
                              key: ValueKey(conversation.id),
                              enabled:
                                  index != 0 && !isHost && conversation.isHost,
                              endActionPane: ActionPane(
                                extentRatio: 0.3,
                                motion: const StretchMotion(),
                                dragDismissible: false,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await showBottomSheetWaterbus(
                                        context: AppRouter.context!,
                                        enableDrag: false,
                                        builder: (context) {
                                          return BottomSheetDelete(
                                            actionText:
                                                Strings.deleteMember.i18n,
                                            description:
                                                Strings.sureDeleteMember.i18n,
                                            handlePressed: () async {
                                              AppBloc.chatBloc.add(
                                                ChatMemberDeleted(
                                                  roomId: conversation.id,
                                                  userModel:
                                                      members[index].user,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: colorHigh,
                                    foregroundColor: mCL,
                                    icon: PhosphorIcons.trash(),
                                    label: Strings.delete.i18n,
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 4.sp,
                                  bottom:
                                      index == members.length - 1 ? 4.sp : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MemberCard(
                                      member: members[index],
                                      isHost: isHost,
                                    ),
                                    if (index != members.length - 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 4.sp,
                                          left: 50.sp,
                                        ),
                                        child: const Divider(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: members.length,
                    ),
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
