import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

class EnterMeetingCode extends StatefulWidget {
  const EnterMeetingCode({super.key});

  @override
  State<StatefulWidget> createState() => _EnterMeetingCardState();
}

class _EnterMeetingCardState extends State {
  final GlobalKey<FormState> _formStateKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();

  void _onSubmited() {
    if (!(_formStateKey.currentState?.validate() ?? false)) return;

    displayLoadingLayer();

    AppBloc.roomBloc.add(RoomInfoGot(roomCode: _codeController.text));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): _onSubmited,
        const SingleActivator(LogicalKeyboardKey.escape): AppRouter.pop,
      },
      child: Scaffold(
        appBar: appBarTitleBack(
          context,
          title: Strings.joinAMeeting.i18n,
          actions: [
            GestureWrapper(
              onTap: () {
                _onSubmited();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 12.sp,
                ),
                color: Colors.transparent,
                alignment: Alignment.bottomRight,
                child: Text(
                  Strings.join.i18n,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Form(
            key: _formStateKey,
            child: Column(
              children: [
                SizedBox(height: 12.sp),
                Text(
                  Strings.participationInstructions.i18n,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12.sp,
                      ),
                ),
                SizedBox(height: 24.sp),
                EnterCodeBox(
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(
                    left: 16.sp,
                    right: 10.sp,
                  ),
                  hintTextContent: "abc-abcd-abc",
                  controller: _codeController,
                  onFieldSubmitted: (val) {
                    _onSubmited();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
