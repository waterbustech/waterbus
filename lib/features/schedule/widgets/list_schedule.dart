// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';
import 'package:waterbus/features/schedule/widgets/date_schedule_card.dart';

class ListSchedule extends StatelessWidget {
  const ListSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            final DateTime date =
                state is ScheduleLoaded ? state.selectedDate : DateTime.now();
            return DateScheduleCard(date: date);
          },
        ),
      ),
    );
  }
}
