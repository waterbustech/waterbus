import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/label_text.dart';
import 'package:waterbus/gen/assets.gen.dart';

class EnterRoomPasswordScreen extends StatefulWidget {
  final Room room;
  const EnterRoomPasswordScreen({
    super.key,
    required this.room,
  });

  @override
  State<StatefulWidget> createState() => _EnterRoomPasswordScreenState();
}

class _EnterRoomPasswordScreenState extends State<EnterRoomPasswordScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.enterPassword.i18n,
        onBackPressed: () {
          AppBloc.roomBloc.add(RoomDisposed());
          AppNavigator.pop();
        },
        actions: [
          GestureWrapper(
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.roomBloc.add(
                RoomJoinedWithPassword(
                  password: _passwordController.text,
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp),
              child: Text(
                Strings.join.i18n,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formStateKey,
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        child: Lottie.asset(
                          kIsWeb
                              ? Assets.lotties.unlockLottie
                              : Assets.lotties.broadcastLottie,
                          width: 130.sp,
                          height: 130.sp,
                          fit: BoxFit.contain,
                          frameRate: FrameRate.max,
                          repeat: true,
                        ),
                      ),
                      Text(
                        widget.room.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 12.sp),
                      widget.room.isNoOneElse
                          ? Text(
                              Strings.noParticipantsYet.i18n,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 11.sp),
                            )
                          : StackAvatar(
                              label: widget.room.members
                                  .map(
                                    (user) => user.user.fullName,
                                  )
                                  .toList(),
                              images: widget.room.members
                                  .map(
                                    (user) => user.user.avatar,
                                  )
                                  .toList(),
                              size: 20.sp,
                            ),
                      widget.room.participantsOnlineTile != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.sp),
                              child: Text(
                                widget.room.participantsOnlineTile!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : SizedBox(height: 12.sp),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: LabelText(label: 'Password'),
                      ),
                      TextFieldInput(
                        autofocus: true,
                        obscureText: true,
                        validatorForm: (val) {
                          if (val == null || val.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                        hintText: 'Password',
                        controller: _passwordController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
