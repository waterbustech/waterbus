import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';

class DateTitleCard extends StatelessWidget {
  final DateTime lastJoinedAt;

  const DateTitleCard({super.key, required this.lastJoinedAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.sp,
        horizontal: 10.sp,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        DateTimeHelper().isEqualTwoDate(lastJoinedAt, DateTime.now())
            ? Strings.today.i18n
            : DateFormat('MMMM dd', 'en_US').format(lastJoinedAt),
        style:
            Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 9.25.sp),
      ),
    );
  }
}
