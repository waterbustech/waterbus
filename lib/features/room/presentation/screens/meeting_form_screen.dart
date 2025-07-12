import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/label_text.dart';

class MeetingFormScreen extends StatefulWidget {
  final bool isChatScreen;
  final bool isEdit;
  const MeetingFormScreen({
    super.key,
    this.isChatScreen = false,
    this.isEdit = false,
  });

  @override
  State<MeetingFormScreen> createState() => _MeetingFormScreenState();
}

class _MeetingFormScreenState extends State<MeetingFormScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final bool _isEditing = widget.isEdit;

  @override
  void initState() {
    super.initState();

    if (AppBloc.userBloc.user?.fullName != null) {
      _roomNameController.text = AppBloc.chatBloc.conversationCurrent?.title ??
          '${Strings.meetingWith.i18n} ${AppBloc.userBloc.user!.fullName}';
    }
  }

  void handleCreateMeetingButton() {
    if (!(_formStateKey.currentState?.validate() ?? false)) return;

    displayLoadingLayer();

    if (widget.isChatScreen) {
      if (_isEditing) {
        AppBloc.chatBloc.add(
          ChatUpdated(
            title: _roomNameController.text,
            password: _passwordController.text,
          ),
        );
      } else {
        AppBloc.chatBloc.add(
          ChatCreated(
            title: _roomNameController.text,
            password: _passwordController.text,
          ),
        );
      }
    } else {
      if (_isEditing) {
        AppBloc.roomBloc.add(
          RoomUpdated(
            roomName: _roomNameController.text.trim(),
            password: _passwordController.text,
          ),
        );
      } else {
        AppBloc.roomBloc.add(
          RoomCreated(
            roomName: _roomNameController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter):
            handleCreateMeetingButton,
      },
      child: Scaffold(
        appBar: appBarTitleBack(
          context,
          title: _isEditing
              ? Strings.editMeeting.i18n
              : Strings.createMeeting.i18n,
          actions: [
            IconButton(
              onPressed: () {
                if (!(_formStateKey.currentState?.validate() ?? false)) return;

                displayLoadingLayer();

                if (widget.isChatScreen) {
                  if (_isEditing) {
                    AppBloc.chatBloc.add(
                      ChatUpdated(
                        title: _roomNameController.text,
                        password: _passwordController.text,
                      ),
                    );
                  } else {
                    AppBloc.chatBloc.add(
                      ChatCreated(
                        title: _roomNameController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                } else {
                  if (_isEditing) {
                    AppBloc.roomBloc.add(
                      RoomUpdated(
                        roomName: _roomNameController.text.trim(),
                        password: _passwordController.text,
                      ),
                    );
                  } else {
                    AppBloc.roomBloc.add(
                      RoomCreated(
                        roomName: _roomNameController.text.trim(),
                        password: _passwordController.text,
                      ),
                    );
                  }
                }
              },
              icon: Icon(
                PhosphorIcons.check(),
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
      ),
    );
  }
}
