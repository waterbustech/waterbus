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
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';
import 'package:waterbus/features/meeting/presentation/widgets/preview_camera_card.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (AppBloc.userBloc.user?.fullName != null) {
      _roomNameController.text =
          'Meeting with ${AppBloc.userBloc.user!.fullName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Create Meeting',
        actions: [
          IconButton(
            onPressed: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              showDialogLoading();

              AppBloc.meetingBloc.add(
                CreateMeetingEvent(
                  roomName: _roomNameController.text,
                  password: _passwordController.text,
                ),
              );
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.sp),
                        child: const PreviewCameraCard(),
                      ),
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
                          if (val?.isEmpty ?? true) return null;

                          if (val!.length < 6) {
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
