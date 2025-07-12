import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:popover/popover.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/conversation/widgets/more_action_item.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';

class DetailGroupButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;

  const DetailGroupButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  bool get _isHost => AppBloc.chatBloc.conversationCurrent?.isHost ?? false;

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: icon == PhosphorIcons.dotsThreeOutline()
          ? () {
              showPopover(
                context: context,
                bodyBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isHost)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoreActionItem(
                            title: Strings.archivedChats.i18n,
                            icon: PhosphorIcons.archive(),
                            textColor: Theme.of(context).colorScheme.primary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              AppBloc.chatBloc.add(ChatArchived());
                            },
                          ),
                          divider,
                        ],
                      ),
                    MoreActionItem(
                      title: Strings.delete.i18n,
                      icon: PhosphorIcons.trash(),
                      onTap: () {
                        AppBloc.chatBloc.add(ChatDeleted());
                      },
                    ),
                    if (!_isHost)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          divider,
                          MoreActionItem(
                            title: Strings.leaveGroup.i18n,
                            icon: PhosphorIcons.signOut(),
                            onTap: () {
                              AppBloc.chatBloc.add(ChatLeft());
                            },
                          ),
                        ],
                      ),
                  ],
                ),
                width: 145.sp,
                radius: 12.sp,
                barrierColor: Colors.black38,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                arrowHeight: 8.sp,
                arrowWidth: 12.sp,
              );
            }
          : onTap,
      child: Container(
        width: 64.sp,
        decoration: ShapeDecoration(
          shape: SuperellipseShape(
            borderRadius: BorderRadius.circular(25.sp),
          ),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 2.sp),
            Text(
              title.toLowerCase(),
              style: TextStyle(
                fontSize: 9.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
