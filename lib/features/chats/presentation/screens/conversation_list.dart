import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/chats/presentation/widgets/chat_card.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus_sdk/types/index.dart';

class ConversationList extends StatelessWidget {
  final Meeting? currentChat;
  final List<Meeting> meetings;
  final Function(int) onTap;

  const ConversationList({
    super.key,
    required this.currentChat,
    required this.onTap,
    required this.meetings,
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
        meetings.isEmpty
            ? const SizedBox()
            : Expanded(
                child: ListView.builder(
                  itemCount: meetings.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: SizerUtil.isDesktop ? 25.sp : 70.sp,
                    top: 8.sp,
                  ),
                  itemBuilder: (context, index) {
                    return GestureWrapper(
                      onLongPress: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black12,
                          enableDrag: false,
                          builder: (context) {
                            return BottomChatOptions(meeting: meetings[index]);
                          },
                        );
                      },
                      onTap: () {
                        onTap.call(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.sp,
                          vertical: 4.sp,
                        ),
                        color: SizerUtil.isDesktop &&
                                currentChat == meetings[index]
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.2)
                            : Colors.transparent,
                        child: ChatCard(
                          meeting: meetings[index],
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
