import 'package:flutter/material.dart';

import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

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
      Strings.readyToJoin.i18n,
      style: TextStyle(
        fontSize: 22.sp,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double widthButton = context.isMobile ? 100.w : 230.sp;

    return Form(
      key: _formStateKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _readyJoinText(context),
          widget.isMember
              ? SizedBox(height: 20.sp)
              : Padding(
                  padding: EdgeInsets.only(top: 16.sp, bottom: 12.sp),
                  child: SizedBox(
                    width: widthButton,
                    child: TextFieldInput(
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
                      borderRadius: BorderRadius.circular(4.sp),
                      height: 36.sp,
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
            child: Material(
              shape: SuperellipseShape(
                borderRadius: BorderRadiusGeometry.circular(10.sp),
              ),
              clipBehavior: Clip.hardEdge,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SizedBox(
                height: 36.sp,
                width: widthButton,
                child: Center(
                  child: Text(
                    Strings.joinNow.i18n,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: mCL,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.sp),
          GestureWrapper(
            onTap: () {
              AppBloc.roomBloc.add(RoomDisposed());
              AppRouter.pop();
            },
            child: Center(
              child: Text(
                Strings.leave.i18n,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
