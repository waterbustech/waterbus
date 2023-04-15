// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/schedule/widgets/schedule_card.dart';

class DateScheduleCard extends StatelessWidget {
  final DateTime date;
  const DateScheduleCard({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35.sp,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateTimeHelper().getDayName(date).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: fCL,
                ),
              ),
              SizedBox(height: 2.sp),
              Text(
                date.day.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 15.sp),
        Expanded(
          child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const ScheduleCard();
            },
          ),
        ),
      ],
    );
  }
}
