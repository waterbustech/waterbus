// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/helpers/date_time_helper.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

@injectable
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  DateTime selectedDate = DateTime.now().subtract(
    Duration(hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().minute),
  );
  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) {
      if (event is SeleteDateEvent) {
        _pickDate(event.date);
        emit(_getScheduleLoaded);
      }
      if (event is NextMonthEvent) {
        _updateMonth();
        emit(_getScheduleLoaded);
      }
      if (event is PreviousMonthEvent) {
        _updateMonth(isNext: false);
        emit(_getScheduleLoaded);
      }
    });
  }

  // MARK: Private methods
  ScheduleLoaded get _getScheduleLoaded {
    return ScheduleLoaded(
      selectedDate: selectedDate,
    );
  }

  _pickDate(DateTime date) {
    selectedDate = date;
  }

  _updateMonth({bool isNext = true}) {
    int currentMonth = selectedDate.month;
    if (isNext) {
      selectedDate = selectedDate.add(
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
      selectedDate = selectedDate.subtract(
        Duration(
          days: DateTimeHelper.dayCountMonth[currentMonth - 1],
        ),
      );
    }
  }
}
