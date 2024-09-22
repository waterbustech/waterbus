import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/programing_languages.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/meeting/presentation/widgets/select_programing_languages.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class CodeToolbox extends StatefulWidget {
  const CodeToolbox({super.key});

  @override
  State<StatefulWidget> createState() => _CodeToolboxState();
}

class _CodeToolboxState extends State<CodeToolbox> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blueGrey.shade900,
      child: Row(
        children: [
          _buildOptionItem(
            title: 'Language',
            value: 'Cpp',
            onTap: () {
              showDialogWaterbus(
                maxHeight: 80.h,
                maxWidth: 80.w,
                backgroundColor: const Color(0xFF1c1c1c),
                child: SelectProgramingLanguagesDialog(
                  languague: programmingLanguages.first,
                ),
              );
            },
          ),
          _buildOptionItem(title: 'Theme', value: 'Dracular'),
          _buildOptionItem(title: 'Font', value: 'Jetbrains Mono'),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required String value,
    Function()? onTap,
  }) {
    return GestureWrapper(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.sp,
          vertical: 6.sp,
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: FontFamily.jetbrainsMono,
                  color: mC,
                ),
                children: [
                  TextSpan(text: '$title: '),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.sp),
            Icon(
              Icons.arrow_drop_down,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
