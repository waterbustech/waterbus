import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_text_field.dart';

class EditConversationScreen extends StatefulWidget {
  const EditConversationScreen({super.key});

  @override
  State<EditConversationScreen> createState() => _EditConversationScreenState();
}

class _EditConversationScreenState extends State<EditConversationScreen> {
  final TextEditingController _conversationNameController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _conversationNameController.text =
        AppBloc.chatBloc.conversationCurrent?.title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBarTitleBack(
        context,
        leadingWidth: 60.sp,
        leading: GestureWrapper(
          onTap: () {
            AppNavigator.pop();
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
            onTap: () async {
              if (_formStateKey.currentState!.validate()) {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }

                AppBloc.chatBloc.add(
                  UpdateConversationEvent(
                    title: _conversationNameController.text,
                  ),
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp)
                  .add(EdgeInsets.only(right: SizerUtil.isDesktop ? 12.sp : 0)),
              child: Text(
                Strings.done.i18n,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Form(
          key: _formStateKey,
          child: Column(
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ActiveChatState) {
                    return state.conversationCurrent == null
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(top: 62.sp),
                            child: Align(
                              child: GestureWrapper(
                                child: AvatarChat(
                                  meeting: state.conversationCurrent!.copyWith(
                                    avatar: state.conversationCurrent!.avatar,
                                  ),
                                  size: 80.sp,
                                ),
                              ),
                            ),
                          );
                  }

                  return const SizedBox();
                },
              ),
              SizedBox(height: 4.sp),
              GestureWrapper(
                onTap: () async {
                  await WaterbusImagePicker().openImagePicker(
                    context: context,
                    handleFinish: (image) async {
                      AppBloc.chatBloc
                          .add(UpdateAvatarConversationEvent(avatar: image));
                    },
                  );
                },
                child: Text(
                  Strings.setNewPhoto.i18n,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.sp),
              ProfileTextField(
                focusNode: _focusNode,
                controller: _conversationNameController,
                hintText: Strings.meetingLabel.i18n,
                margin: EdgeInsets.zero,
                validatorForm: (val) {
                  if (val?.isEmpty ?? true) {
                    return Strings.invalidName.i18n;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
