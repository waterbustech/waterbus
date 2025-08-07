import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/domain/entities/check_username_status.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_text_field.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  Timer? _debounce;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = AppBloc.userBloc.user?.userName ?? "";
  }

  void _handleChangeUsername() {
    if (_usernameController.text.length < 5) return;

    if (_isActive) {
      AppBloc.userBloc.add(
        UserUsernameUpdated(username: _usernameController.text),
      );
    }
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
            AppRouter.pop();
          },
          child: Center(
            child: Text(
              Strings.cancel.i18n,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        actions: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserDone) {
                final CheckUsernameStatus status = state.checkUsernameStatus;
                if (status != CheckUsernameStatus.checking) {
                  _isActive = status == CheckUsernameStatus.valid &&
                      _isValidatorUsernameText;
                }

                return GestureWrapper(
                  onTap: _handleChangeUsername,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    padding: EdgeInsets.all(12.sp).add(
                      EdgeInsets.only(right: context.isDesktop ? 12.sp : 0),
                    ),
                    child: Text(
                      Strings.done.i18n,
                      style: TextStyle(
                        color: _isActive
                            ? Theme.of(context).colorScheme.primary
                            : mGB,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[A-Za-z0-9_]*$'),
                      replacementString: AppBloc.userBloc.user?.userName ?? "",
                    ),
                  ],
                  onEditingComplete: _handleChangeUsername,
                  controller: _usernameController,
                  hintText: Strings.username.i18n,
                  margin: EdgeInsets.only(top: 5.sp),
                  onChanged: (val) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(
                      const Duration(milliseconds: 500),
                      () {
                        AppBloc.userBloc.add(
                          UserUsernameChecked(
                            username: _usernameController.text,
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserDone) {
                      final CheckUsernameStatus status =
                          state.checkUsernameStatus;

                      return Visibility(
                        visible: status != CheckUsernameStatus.none &&
                            _isValidatorUsernameText,
                        child: Column(
                          children: [
                            SizedBox(height: 6.sp),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.sp),
                              child: Row(
                                children: [
                                  status == CheckUsernameStatus.checking
                                      ? CupertinoActivityIndicator(radius: 5.sp)
                                      : Icon(
                                          status == CheckUsernameStatus.valid
                                              ? Icons.check
                                              : Icons.close,
                                          size: 12.sp,
                                          color: status.colorByStatus,
                                        ),
                                  SizedBox(width: 10.sp),
                                  Text(
                                    status.titleByStatus,
                                    style: TextStyle(
                                      color: status.colorByStatus,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6.sp),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
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

  bool get _isValidatorUsernameText =>
      AppBloc.userBloc.user?.userName != _usernameController.text &&
      _usernameController.text.length >= 5;
}
