// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
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
  final bool isSettingDesktop;
  const ProfileScreen({super.key, this.isSettingDesktop = false});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _user;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = AppBloc.userBloc.user;

    if (_user != null) {
      _fullNameController.text = _user!.fullName;
      _bioController.text = _user?.bio ?? "";
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
        leading: widget.isSettingDesktop
            ? const SizedBox()
            : GestureWrapper(
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
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.userBloc.add(
                UpdateProfileEvent(
                  fullName: _fullNameController.text,
                  bio: _bioController.text,
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp)
                  .add(EdgeInsets.only(right: SizerUtil.isDesktop ? 12.sp : 0)),
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
                              _user = state is UserGetDone ? state.user : null;

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
                                  child: _user?.avatar == null
                                      ? CircleAvatar(
                                          radius: 35.sp,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(
                                            Assets.images.imgAppLogo.path,
                                          ),
                                        )
                                      : AvatarCard(
                                          urlToImage: _user?.avatar,
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
                                  controller: _fullNameController,
                                  hintText: Strings.fullname.i18n,
                                  margin: EdgeInsets.zero,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: divider,
                                ),
                                GestureWrapper(
                                  onTap: () {
                                    AppNavigator().push(Routes.usernameRoute);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp,
                                      vertical:
                                          SizerUtil.isDesktop ? 8.sp : 10.sp,
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
                                            maxLines: 1,
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
                                            _user = state is UserGetDone
                                                ? state.user
                                                : null;

                                            return _user?.userName == null
                                                ? const SizedBox()
                                                : Container(
                                                    width: SizerUtil.isDesktop
                                                        ? null
                                                        : 45.w,
                                                    padding: EdgeInsets.only(
                                                      right: SizerUtil.isDesktop
                                                          ? 4.sp
                                                          : 2.sp,
                                                    ),
                                                    child: Text(
                                                      "@${_user?.userName ?? ""}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .color,
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
