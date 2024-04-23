// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_text_field.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = AppBloc.userBloc.user?.userName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarTitleBack(
        context,
        title: Strings.username.i18n,
        leadingWidth: 60.sp,
        leading: GestureWrapper(
          onTap: () {
            AppNavigator.pop();
          },
          child: Center(
            child: Text(
              Strings.cancel.i18n,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        actions: [
          GestureWrapper(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp)
                  .add(EdgeInsets.only(right: SizerUtil.isDesktop ? 12.sp : 0)),
              child: Text(
                Strings.done.i18n,
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
      body: Column(
        children: [
          divider,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.sp),
                Padding(
                  padding: EdgeInsets.only(left: 10.sp),
                  child: Text(
                    Strings.username.i18n.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: mGB,
                    ),
                  ),
                ),
                ProfileTextField(
                  controller: _usernameController,
                  hintText: Strings.username.i18n,
                  margin: EdgeInsets.only(top: 5.sp),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.sp)
                      .add(EdgeInsets.symmetric(horizontal: 10.sp)),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: mGB,
                        height: 1.sp,
                      ),
                      children: [
                        TextSpan(
                          text: Strings.usernameNote1.i18n,
                        ),
                        const TextSpan(
                          text: " Waterbus",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: Strings.usernameNote2.i18n,
                        ),
                        const TextSpan(
                          text: " a-z",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text: ",",
                        ),
                        const TextSpan(
                          text: " 0-9 ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: Strings.usernameNote3.i18n,
                        ),
                        const TextSpan(
                          text: " 5 ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: Strings.usernameNote4.i18n,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
