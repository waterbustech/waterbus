import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:popover/popover.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/widgets/more_action_item.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';

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
                routeSettings: const RouteSettings(name: Routes.dialogRoute),
                context: context,
                bodyBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MoreActionItem(
                      title: Strings.delete.i18n,
                      icon: PhosphorIcons.trash(),
                      onTap: () {
                        AppBloc.chatBloc.add(DeleteConversationEvent());
                      },
                    ),
                    divider,
                    MoreActionItem(
                      title: _isHost
                          ? Strings.archivedChats.i18n
                          : Strings.leaveGroup.i18n,
                      icon: _isHost
                          ? PhosphorIcons.archive()
                          : PhosphorIcons.signOut(),
                      onTap: () {
                        AppBloc.chatBloc
                            .add(ArchivedOrLeaveConversationEvent());
                      },
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
