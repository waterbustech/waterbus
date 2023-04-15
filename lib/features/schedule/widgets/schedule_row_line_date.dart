// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';

// Project imports:

class ScheduleRowLineDate extends StatefulWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;

  const ScheduleRowLineDate({
    super.key,
    required this.weekDays,
    required this.selectedDate,
  });
  @override
  State<StatefulWidget> createState() => _ScheduleRowLineDateState();
}

class _ScheduleRowLineDateState extends State<ScheduleRowLineDate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.sp),
      child: Row(
        children: [
          ...widget.weekDays.map((date) => _buildDateButton(date)),
        ],
      ),
    );
  }

  Widget _buildDateButton(DateTime date) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ScheduleBloc>(context)
              .add(SeleteDateEvent(date: date));
        },
        child: Container(
          padding: EdgeInsets.all(5.sp),
          margin: EdgeInsets.symmetric(horizontal: 5.5.sp),
          decoration: BoxDecoration(
            color: DateTimeHelper().isEqualTwoDate(widget.selectedDate, date)
                ? colorPrimary
                : Colors.transparent,
            border: Border.all(
              color: DateTimeHelper().isEqualTwoDate(widget.selectedDate, date)
                  ? colorPrimary
                  : Colors.transparent,
              width: 0.75,
            ),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.5.sp),
              Text(
                date.day.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DateTimeHelper().locatedInThisMonth(
                    date,
                    compareDate:
                        BlocProvider.of<ScheduleBloc>(context).selectedDate,
                  )
                      ? mC
                      : colorGray2,
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
