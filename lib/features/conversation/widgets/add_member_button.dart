import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/conversation/widgets/bottom_sheet_add_member.dart';
import 'package:waterbus/gen/assets.gen.dart';

class AddMemberButton extends StatelessWidget {
  final Meeting conversation;
  const AddMemberButton({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: () {
        showDialogWaterbus(
          child: BottomSheetAddMember(
            meetingId: conversation.id,
            code: conversation.code,
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: 12.sp,
          vertical: 2.sp,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 30.sp,
              child: Image.asset(
                Assets.icons.icAddMembers.path,
                width: 24.sp,
                height: 26.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 8.sp),
            Text(
              Strings.addMembers.i18n,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
