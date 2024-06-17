// Flutter imports:
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/glass_morphism_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/option_button.dart';

// Project imports:
import 'package:waterbus_sdk/types/index.dart';

class BottomChatOptions extends StatelessWidget {
  final Meeting meeting;
  const BottomChatOptions({
    super.key,
    required this.meeting,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizerUtil.isDesktop ? 330.sp : null,
      margin: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: ColoredBox(
              color:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.55),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ButtonOptionWidget(
                        text: "Xoá cuộc trò chuyện",
                        isDanger: true,
                        handlePressed: () {
                          AppBloc.chatBloc.add(
                            DeleteConversationEvent(
                              meetingId: meeting.id,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8.sp),
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: ColoredBox(
              color:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.55),
              child: ButtonOptionWidget(
                text: Strings.cancel.i18n,
                isCancel: true,
              ),
            ),
          ),
          SizedBox(height: 6.sp),
        ],
      ),
    );
  }
}
