// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';
import 'package:waterbus/gen/assets.gen.dart';

class EnterMeetingPasswordScreen extends StatefulWidget {
  final Meeting meeting;
  const EnterMeetingPasswordScreen({
    super.key,
    required this.meeting,
  });

  @override
  State<StatefulWidget> createState() => _EnterMeetingPasswordScreenState();
}

class _EnterMeetingPasswordScreenState
    extends State<EnterMeetingPasswordScreen> {
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
        'Enter password',
        onBackPressed: () {
          AppBloc.meetingBloc.add(DisposeMeetingEvent());
          AppNavigator.pop();
        },
        actions: [
          GestureWrapper(
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.meetingBloc.add(
                JoinMeetingWithPasswordEvent(
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
                'Join',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
                          Assets.lotties.unlockLottie,
                          width: 130.sp,
                          height: 130.sp,
                          fit: BoxFit.contain,
                          frameRate: FrameRate.max,
                          repeat: true,
                        ),
                      ),
                      Text(
                        widget.meeting.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 12.sp),
                      widget.meeting.isNoOneElse
                          ? Text(
                              "No participants yet",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 11.sp),
                            )
                          : StackAvatar(
                              images: widget.meeting.getUniqueUsers
                                  .map(
                                    (user) => user.user.avatar,
                                  )
                                  .toList(),
                              size: 20.sp,
                            ),
                      widget.meeting.participantsOnlineTile != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.sp),
                              child: Text(
                                widget.meeting.participantsOnlineTile!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).primaryColor,
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
