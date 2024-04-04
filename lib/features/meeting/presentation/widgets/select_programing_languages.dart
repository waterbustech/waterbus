// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:re_editor/re_editor.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/constants/programing_languages.dart';

class SelectProgramingLanguagesDialog extends StatefulWidget {
  final Map<String, CodeHighlightThemeMode> languague;

  const SelectProgramingLanguagesDialog({super.key, required this.languague});
  @override
  State<StatefulWidget> createState() =>
      _SelectProgramingLanguagesDialogState();
}

class _SelectProgramingLanguagesDialogState
    extends State<SelectProgramingLanguagesDialog> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          crossAxisSpacing: 4.sp,
          mainAxisSpacing: 4.sp,
          childAspectRatio: 16 / 9,
        ),
        itemCount: programmingLanguages.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Align(
              child: Text(
                programmingLanguages[index].keys.first,
                style: TextStyle(
                  color: widget.languague.keys.first ==
                          programmingLanguages[index].keys.first
                      ? Theme.of(context).primaryColor
                      : null,
                  fontSize: 14.sp,
                  decorationColor: widget.languague.keys.first ==
                          programmingLanguages[index].keys.first
                      ? Theme.of(context).primaryColor
                      : null,
                  decoration: widget.languague.keys.first ==
                          programmingLanguages[index].keys.first
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
