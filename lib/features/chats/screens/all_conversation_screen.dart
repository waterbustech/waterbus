// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/widgets/chat_card.dart';
import 'package:waterbus/features/chats/xmodels/chat_model.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';

class AllConversationScreen extends StatelessWidget {
  final ChatModel? currentChat;
  final Function(int) onTap;
  const AllConversationScreen({
    super.key,
    required this.currentChat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.sp),
        EnterCodeBox(
          hintTextContent: Strings.search.i18n,
          onTap: () {},
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listFakeChat.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: SizerUtil.isDesktop ? 25.sp : 70.sp,
              top: 8.sp,
            ),
            itemBuilder: (context, index) {
              return GestureWrapper(
                onTap: () {
                  onTap.call(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 4.sp,
                  ),
                  color:
                      SizerUtil.isDesktop && currentChat == listFakeChat[index]
                          ? colorPrimary.withOpacity(.2)
                          : Colors.transparent,
                  child: ChatCard(
                    chatModel: listFakeChat[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
