// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/meeting/presentation/widgets/label_text.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _user;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = AppBloc.userBloc.user;

    if (_user != null) {
      _fullNameController.text = _user!.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Profile',
        actions: [
          GestureWrapper(
            onTap: () {
              if (!(_formStateKey.currentState?.validate() ?? false)) return;

              displayLoadingLayer();

              AppBloc.userBloc.add(
                UpdateProfileEvent(fullName: _fullNameController.text),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.sp),
                        Align(
                          child: _user!.avatar == null
                              ? CircleAvatar(
                                  radius: 40.sp,
                                  backgroundColor: Colors.black,
                                  backgroundImage: AssetImage(
                                    Assets.images.imgAppLogo.path,
                                  ),
                                )
                              : AvatarCard(
                                  urlToImage: _user!.avatar,
                                  size: 80.sp,
                                ),
                        ),
                        SizedBox(height: 20.sp),
                        const LabelText(label: 'Full name'),
                        TextFieldInput(
                          validatorForm: (val) {
                            if (val?.isEmpty ?? true) {
                              return "Invalid full name";
                            }

                            return null;
                          },
                          hintText: 'Your full name',
                          controller: _fullNameController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
