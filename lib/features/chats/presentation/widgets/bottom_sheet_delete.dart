import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/chats/presentation/widgets/glass_morphism_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/option_button.dart';

class BottomSheetDelete extends StatelessWidget {
  final Function handlePressed;
  final String? description;
  final String? actionText;
  const BottomSheetDelete({
    super.key,
    required this.handlePressed,
    this.description,
    this.actionText,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 12.sp,
        horizontal: SizerUtil.isDesktop
            ? SizerUtil.isLandscape
                ? 12.w
                : 20.w
            : 10.sp,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 12.sp,
                  ),
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? colorBlackGlassmorphism
                          : Theme.of(context).scaffoldBackgroundColor)
                      .withOpacity(0.7),
                  child: Text(
                    description ?? Strings.sureDeleteConversation.i18n,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.35,
                    ),
                  ),
                ),
                const Divider(),
                ButtonOptionWidget(
                  text: actionText ?? Strings.delete.i18n,
                  isDanger: true,
                  handlePressed: () => handlePressed.call(),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.sp),
          GlassmorphismWrapper(
            borderRadius: BorderRadius.circular(12.sp),
            child: ButtonOptionWidget(
              text: Strings.cancel.i18n,
              handlePressed: () {},
            ),
          ),
          SizedBox(height: 4.sp),
        ],
      ),
    );
  }
}
