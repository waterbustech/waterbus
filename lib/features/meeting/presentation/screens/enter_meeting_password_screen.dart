// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';

class EnterMeetingPasswordScreen extends StatefulWidget {
  const EnterMeetingPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EnterMeetingPasswordScreenState();
}

class _EnterMeetingPasswordScreenState
    extends State<EnterMeetingPasswordScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Enter password',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.sp),
                    const LabelText(label: 'Password'),
                    TextFieldInput(
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
          ],
        ),
      ),
    );
  }
}
