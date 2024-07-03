import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus/features/conversation/xmodels/option_model.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/chats/presentation/widgets/glass_morphism_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/option_button.dart';

class BottomChatOptions extends StatelessWidget {
  final List<OptionModel> options;
  const BottomChatOptions({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizerUtil.isDesktop ? 330.sp : null,
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ButtonOptionWidget(
                      text: options[index].title,
                      isDanger: options[index].isDanger,
                      handlePressed: options[index].handlePressed,
                    ),
                    options.length > 1 && index != options.length - 1
                        ? const Divider()
                        : const SizedBox(),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 8.sp),
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: ButtonOptionWidget(
              text: Strings.cancel.i18n,
            ),
          ),
          SizedBox(height: 12.sp),
        ],
      ),
    );
  }
}
