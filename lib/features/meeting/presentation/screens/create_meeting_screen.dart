import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';

class CreateMeetingScreen extends StatefulWidget {
  final Meeting? meeting;
  final bool isChatScreen;
  const CreateMeetingScreen({
    super.key,
    required this.meeting,
    this.isChatScreen = false,
  });

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final _isEditing = widget.meeting != null;

  @override
  void initState() {
    super.initState();

    if (AppBloc.userBloc.user?.fullName != null) {
      _roomNameController.text = widget.meeting?.title ??
          '${Strings.meetingWith.i18n} ${AppBloc.userBloc.user!.fullName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title:
            _isEditing ? Strings.editMeeting.i18n : Strings.createMeeting.i18n,
        actions: [
          IconButton(
            onPressed: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              if (widget.isChatScreen) {
                AppBloc.chatBloc.add(
                  CreateConversationEvent(
                    title: _roomNameController.text,
                    password: _passwordController.text,
                  ),
                );
              } else {
                if (_isEditing) {
                  AppBloc.meetingBloc.add(
                    UpdateMeetingEvent(
                      roomName: _roomNameController.text,
                      password: _passwordController.text,
                    ),
                  );
                } else {
                  AppBloc.meetingBloc.add(
                    CreateMeetingEvent(
                      roomName: _roomNameController.text,
                      password: _passwordController.text,
                    ),
                  );
                }
              }
            },
            icon: Icon(
              PhosphorIcons.check,
              size: 18.sp,
              color: Theme.of(context).colorScheme.primary,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.sp),
                      LabelText(label: Strings.roomName.i18n),
                      TextFieldInput(
                        validatorForm: (val) {
                          if (val?.isEmpty ?? true) {
                            return Strings.invalidName.i18n;
                          }
                          return null;
                        },
                        hintText: Strings.meetingLabel.i18n,
                        controller: _roomNameController,
                      ),
                      SizedBox(height: 8.sp),
                      LabelText(label: Strings.password.i18n),
                      TextFieldInput(
                        obscureText: true,
                        validatorForm: (val) {
                          if (val == null || val.length < 6) {
                            return Strings
                                .passwordMustBeAtLeast6Characters.i18n;
                          }

                          return null;
                        },
                        hintText: Strings.password.i18n,
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
