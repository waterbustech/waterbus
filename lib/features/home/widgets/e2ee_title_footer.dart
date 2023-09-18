// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
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
                  PhosphorIcons.lock_fill,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  size: 10.sp,
                ),
              ),
            ),
            const TextSpan(text: 'Your personal meetings are '),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const E2eeBottomSheet();
                    },
                  );
                },
              text: 'end-to-end encrypted',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
