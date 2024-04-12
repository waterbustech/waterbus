// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/core/lang/localization.dart';

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
      decoration: BoxDecoration(color: Colors.blueGrey.shade900),
      alignment: Alignment.centerLeft,
      child: Text(
        DateTimeHelper().isEqualTwoDate(lastJoinedAt, DateTime.now())
            ? Strings.today.i18n
            : DateFormat('EEEEE dd', 'en_US').format(lastJoinedAt),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 9.25.sp,
            ),
      ),
    );
  }
}
