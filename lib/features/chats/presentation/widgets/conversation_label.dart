import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

class ConversationLabel extends StatelessWidget {
  const ConversationLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Text(
        Strings.chat.i18n,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15.sp,
            ),
      ),
    );
  }
}
