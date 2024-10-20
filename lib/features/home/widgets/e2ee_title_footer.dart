import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/meeting/presentation/widgets/e2ee_bottom_sheet.dart';

class E2eeTitleFooter extends StatelessWidget {
  const E2eeTitleFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.sp),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 9.25.sp,
              ),
          children: [
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(right: 4.sp),
                child: Icon(
                  PhosphorIcons.lock(PhosphorIconsStyle.fill),
                  color: Theme.of(context).colorScheme.surfaceTint,
                  size: 10.sp,
                ),
              ),
            ),
            TextSpan(text: Strings.yourPersonalMeetingsAre.i18n),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialogWaterbus(
                    alignment: Alignment.center,
                    child: const E2eeBottomSheet(),
                  );
                },
              text: Strings.endToEndEncrypted.i18n,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
