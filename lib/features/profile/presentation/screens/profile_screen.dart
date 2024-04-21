// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
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
        title: Strings.profile.i18n,
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
                Strings.save.i18n,
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
                                          radius: 35.sp,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(
                                            Assets.images.imgAppLogo.path,
                                          ),
                                        )
                                      : AvatarCard(
                                          urlToImage: user?.avatar,
                                          size: 70.sp,
                                        ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 25.sp),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.sp),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  controller: _firstNameController,
                                  hintText: Strings.firstname.i18n,
                                  margin: EdgeInsets.zero,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: divider,
                                ),
                                ProfileTextField(
                                  controller: _lastNameController,
                                  hintText: Strings.lastname.i18n,
                                  margin: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                          _TextFieldNote(
                            note: Strings
                                .enterYourNameAndAddAnOptionalProfilePhoto.i18n,
                          ),
                          ProfileTextField(
                            controller: _bioController,
                            hintText: Strings.bio.i18n,
                            margin: EdgeInsets.only(top: 16.sp),
                          ),
                          _TextFieldNote(
                            note: Strings.youCanAddFewLinesAboutYourself.i18n,
                          ),
                          GestureWrapper(
                            onTap: () {
                              AppNavigator().push(Routes.usernameRoute);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 16.sp),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: SizerUtil.isDesktop ? 8.sp : 10.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.sp),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Strings.username.i18n,
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
                                    PhosphorIcons.caret_right,
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
                                vertical: SizerUtil.isDesktop ? 8.sp : 10.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.sp),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Text(
                                  Strings.logout.i18n,
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
