// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class ScheduleTitle extends StatelessWidget {
  final TextStyle textStyle;
  final bool isBigStyle;
  final int? dayCurrent;

  ScheduleTitle({
    super.key,
    required this.textStyle,
    this.isBigStyle = false,
    this.dayCurrent,
  });

  final List<String> calendarTitle = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...calendarTitle.map(
          (title) => _buildTitle(
            context: context,
            title: title,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle({
    required BuildContext context,
    required String title,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.sp,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
