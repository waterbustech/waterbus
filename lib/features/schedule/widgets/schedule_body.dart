import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';
import 'package:waterbus/features/schedule/widgets/schedule_row_line_date.dart';
import 'package:waterbus/features/schedule/widgets/schedule_title.dart';

class ScheduleBody extends StatefulWidget {
  final DateTime selectedDate;
  const ScheduleBody({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  int _currentIndex = unlimited;
  final controller = PageController(initialPage: unlimited);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Column(
        children: [
          ScheduleTitle(
            dayCurrent: widget.selectedDate.weekday - 1,
            textStyle: TextStyle(
              fontSize: 11.sp,
              color: colorDarkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(
            height: 1.sp,
          ),
          SizedBox(height: 2.sp),
          Container(
            // key: widget.ScheduleKey,
            height: (DateTimeHelper()
                        .getScheduleThisMonth(dateTime: widget.selectedDate)
                        .length +
                    1) *
                25.sp,
            // color: colorPrimaryBlack,
            color: Colors.transparent,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                if (index < _currentIndex) {
                  BlocProvider.of<ScheduleBloc>(context)
                      .add(PreviousMonthEvent());
                } else {
                  BlocProvider.of<ScheduleBloc>(context).add(NextMonthEvent());
                }
                _currentIndex = index;
              },
              itemBuilder: (context, index) => Opacity(
                opacity: _currentIndex != index ? 0.6 : 1,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ...DateTimeHelper()
                            .getScheduleThisMonth(
                              dateTime: _currentIndex != index
                                  ? _getNextOrPreviousDateTime(
                                      isNext: index > _currentIndex,
                                    )
                                  : widget.selectedDate,
                            )
                            .map(
                              (weeks) => ScheduleRowLineDate(
                                weekDays: weeks,
                                selectedDate: widget.selectedDate,
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getNextOrPreviousDateTime({bool isNext = true}) {
    int currentMonth = widget.selectedDate.month;
    if (isNext) {
      return widget.selectedDate.add(
        Duration(
          days: DateTimeHelper.dayCountMonth[currentMonth - 1],
        ),
      );
    } else {
      currentMonth -= 1;
      if (currentMonth > 12) {
        currentMonth = 1;
      } else if (currentMonth < 1) {
        currentMonth = 12;
      }
      return widget.selectedDate.subtract(
        Duration(
          days: DateTimeHelper.dayCountMonth[currentMonth - 1],
        ),
      );
    }
  }
}
