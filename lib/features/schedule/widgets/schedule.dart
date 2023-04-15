// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';
import 'package:waterbus/features/schedule/widgets/schedule_body.dart';
import 'package:waterbus/features/schedule/widgets/schedule_header.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ScheduleHeader(),
        SizedBox(height: 15.sp),
        BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleBody(
                  selectedDate: state is ScheduleLoaded
                      ? state.selectedDate
                      : DateTime.now(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
