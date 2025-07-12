import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/screens/username_screen.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_text_field.dart';

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
          GestureWrapper(
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.userBloc.add(
                UserUpdated(
                  fullName: _fullNameController.text,
                  bio: _bioController.text,
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(12.sp),
              child: Text(
                Strings.save.i18n,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
                              _user = state is UserDone ? state.user : null;

                              return Align(
                                child: GestureWrapper(
                                  onTap: () {
                                    WaterbusImagePicker().openImagePicker(
                                      context: context,
                                      handleFinish: (image) {
                                        displayLoadingLayer();

                                        AppBloc.userBloc.add(
                                          UserAvatarUpdated(image: image),
                                        );
                                      },
                                    );
                                  },
                                  child: AvatarCard(
                                    urlToImage: _user?.avatar,
                                    size: 70.sp,
                                    label: _user?.fullName,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 25.sp),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.sp),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
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
                                    if (context.isMobile) {
                                      UsernameRoute().push(context);
                                    } else {
                                      showScreenAsDialog(
                                        route: Routes.usernameRoute,
                                        child: UserNameScreen(),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp,
                                      vertical:
                                          context.isDesktop ? 8.sp : 10.sp,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.sp),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onInverseSurface,
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
                                            _user = state is UserDone
                                                ? state.user
                                                : null;

                                            return _user?.userName == null
                                                ? const SizedBox()
                                                : Container(
                                                    width: context.isDesktop
                                                        ? null
                                                        : 45.w,
                                                    padding: EdgeInsets.only(
                                                      right: context.isDesktop
                                                          ? 4.sp
                                                          : 2.sp,
                                                    ),
                                                    child: Text(
                                                      "@${_user?.userName ?? ""}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.right,
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
                                          PhosphorIcons.caretRight(),
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
                              AppBloc.authBloc.add(AuthLoggedOut());
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20.sp),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: context.isDesktop ? 8.sp : 10.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.sp),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
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
