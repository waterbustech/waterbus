import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
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
        title: 'Username',
        leadingWidth: 60.sp,
        leading: GestureWrapper(
          onTap: () {
            AppNavigator.pop();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            padding: EdgeInsets.only(
              top: 12.sp,
              left: 12.sp,
            ),
            child: Text(
              'Cancel',
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
              padding: EdgeInsets.all(12.sp),
              child: Text(
                'Done',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.sp),
            Padding(
              padding: EdgeInsets.only(left: 10.sp),
              child: Text(
                "USERNAME",
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: mGB,
                ),
              ),
            ),
            ProfileTextField(
              controller: _usernameController,
              hintText: 'Username',
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
                  children: const [
                    TextSpan(
                      text: "You can choose a username an ",
                    ),
                    TextSpan(
                      text: "Waterbus",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ". If you do, people will be able to find you by this username and contact your.\n\nYou can use ",
                    ),
                    TextSpan(
                      text: "a-z",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ", ",
                    ),
                    TextSpan(
                      text: "0-9",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: " and underscores. Minium length is ",
                    ),
                    TextSpan(
                      text: "5",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: " characters.",
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
