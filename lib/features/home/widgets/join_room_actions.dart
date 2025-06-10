import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class JoinRoomActions extends StatefulWidget {
  final Room room;
  final bool isMember;

  const JoinRoomActions({
    super.key,
    required this.room,
    required this.isMember,
  });

  @override
  State<JoinRoomActions> createState() => _JoinRoomActionsState();
}

class _JoinRoomActionsState extends State<JoinRoomActions> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  Text _readyJoinText(BuildContext context) {
    return Text(
      widget.isMember ? 'Ready to join?' : 'Join with password!',
      style: TextStyle(
        fontSize: 22.sp,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }

  double _getFirstLineWidth({required Text text, required double maxWidth}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.data,
        style: text.style?.copyWith(fontFamily: FontFamily.helvetica),
      ),
      maxLines: 1,
      textScaler: TextScaler.linear(1),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    final double widthButton = context.isMobile
        ? 100.w
        : _getFirstLineWidth(
            text: _readyJoinText(context),
            maxWidth: 40.w,
          );

    return Form(
      key: _formStateKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _readyJoinText(context),
          if (!widget.isMember)
            Padding(
              padding: EdgeInsets.only(top: 16.sp),
              child: SizedBox(
                width: widthButton,
                child: TextFieldInput(
                  autofocus: true,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.labelSmall?.color,
                    fontSize: 12.sp,
                  ),
                  obscureText: true,
                  validatorForm: (val) => null,
                  hintText: Strings.password.i18n,
                  controller: _passwordController,
                ),
              ),
            ),
          SizedBox(height: 20.sp),
          GestureWrapper(
            onTap: () {
              if (!widget.isMember && _passwordController.text.length < 6) {
                Strings.passwordMustBeAtLeast6Characters.i18n
                    .showToast(ToastificationType.error);
                return;
              }

              AppBloc.roomBloc.add(
                RoomJoinedEvent(
                  room: widget.room,
                  isMember: widget.isMember,
                  password: _passwordController.text,
                ),
              );
            },
            child: Container(
              width: widthButton,
              padding: EdgeInsets.symmetric(vertical: 10.sp),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Text(
                  'Join now',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: mCL,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.sp),
          GestureWrapper(
            onTap: () {
              AppBloc.roomBloc.add(RoomDisposed());
              AppNavigator.pop();
            },
            child: Container(
              width: widthButton,
              padding: EdgeInsets.symmetric(vertical: 8.5.sp),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                ),
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Text(
                  "Leave",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
