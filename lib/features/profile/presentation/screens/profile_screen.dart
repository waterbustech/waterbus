// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _user;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = AppBloc.userBloc.user;

    if (_user != null) {
      _firstNameController.text = _user!.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarTitleBack(
        context,
        title: 'Profile',
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
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.userBloc.add(
                UpdateProfileEvent(fullName: _firstNameController.text),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp),
              child: Text(
                'Save',
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
      body: _user == null
          ? const SizedBox()
          : Form(
              key: _formStateKey,
              child: Column(
                children: [
                  const Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.sp),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              final User? user =
                                  state is UserGetDone ? state.user : null;

                              return Align(
                                child: GestureWrapper(
                                  onTap: () {
                                    WaterbusImagePicker().openImagePicker(
                                      context: context,
                                      handleFinish: (image) {
                                        displayLoadingLayer();

                                        AppBloc.userBloc.add(
                                          UpdateAvatarEvent(image: image),
                                        );
                                      },
                                    );
                                  },
                                  child: user?.avatar == null
                                      ? CircleAvatar(
                                          radius: 40.sp,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(
                                            Assets.images.imgAppLogo.path,
                                          ),
                                        )
                                      : AvatarCard(
                                          urlToImage: user?.avatar,
                                          size: 80.sp,
                                        ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 25.sp),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.sp),
                              color: colorBlueGreyDark,
                            ),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  controller: _firstNameController,
                                  hintText: 'First name',
                                  margin: EdgeInsets.zero,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: divider,
                                ),
                                ProfileTextField(
                                  controller: _lastNameController,
                                  hintText: 'Last name',
                                  margin: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                          const _TextFieldNote(
                            note:
                                "Enter your name and add an optional profile photo.",
                          ),
                          ProfileTextField(
                            controller: _bioController,
                            hintText: 'Bio',
                            margin: EdgeInsets.only(top: 16.sp),
                          ),
                          const _TextFieldNote(
                            note: "You can add a few lines about yourself.",
                          ),
                          GestureWrapper(
                            onTap: () {
                              AppNavigator().push(Routes.usernameRoute);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 16.sp),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: 7.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.sp),
                                color: colorBlueGreyDark,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<UserBloc, UserState>(
                                    builder: (context, state) {
                                      final User? user = state is UserGetDone
                                          ? state.user
                                          : null;

                                      return user?.userName == null
                                          ? const SizedBox()
                                          : Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: SizerUtil.isDesktop
                                                      ? 4.sp
                                                      : 2.sp,
                                                ),
                                                child: Text(
                                                  "@${user?.userName ?? ""}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .color,
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: colorGray3,
                                    size: 18.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureWrapper(
                            onTap: () {
                              displayLoadingLayer();
                              AppBloc.authBloc.add(LogOutEvent());
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20.sp),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: 7.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.sp),
                                color: colorBlueGreyDark,
                              ),
                              child: Center(
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
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

class _TextFieldNote extends StatelessWidget {
  final String note;

  const _TextFieldNote({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 5.sp,
      ),
      child: Text(
        note,
        style: TextStyle(
          fontSize: 9.sp,
          color: mGB,
        ),
      ),
    );
  }
}
