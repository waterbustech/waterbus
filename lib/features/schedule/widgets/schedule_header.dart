import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Row(
        children: [
          BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              final DateTime date =
                  state is! ScheduleLoaded ? DateTime.now() : state.props[0];
              return Text(
                '${DateTimeHelper.listMonth[(int.parse(DateTimeHelper().addZeroPrefix(date.month)) - 1)]}  ${date.year}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          SizedBox(width: 10.sp),
          Icon(
            PhosphorIcons.caret_down_bold,
            color: Colors.grey,
            size: 10.sp,
          ),
          const Spacer(),
          Icon(
            PhosphorIcons.plus_bold,
            color: Colors.blue.shade700,
            size: 15.sp,
          )
        ],
      ),
    );
  }
}
