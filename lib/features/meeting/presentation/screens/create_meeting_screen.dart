// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';

class CreateMeetingScreen extends StatefulWidget {
  final Meeting? meeting;
  const CreateMeetingScreen({
    super.key,
    required this.meeting,
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
          'Meeting with ${AppBloc.userBloc.user!.fullName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: _isEditing ? 'Edit Meeting' : 'Create Meeting',
        actions: [
          IconButton(
            onPressed: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

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
            },
            icon: Icon(
              PhosphorIcons.check,
              size: 18.sp,
              color: Theme.of(context).primaryColor,
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
                      const LabelText(label: 'Room name'),
                      TextFieldInput(
                        validatorForm: (val) {
                          if (val?.isEmpty ?? true) return "Invalid name";

                          return null;
                        },
                        hintText: 'Meeting label',
                        controller: _roomNameController,
                      ),
                      SizedBox(height: 8.sp),
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
            ),
          ],
        ),
      ),
    );
  }
}
