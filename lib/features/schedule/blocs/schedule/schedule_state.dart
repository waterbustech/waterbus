part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleState {
  List<dynamic> get props => [];
}

class ScheduleInitial extends ScheduleState {
  @override
  List get props => [];
}

class ScheduleLoaded extends ScheduleState {
  final DateTime selectedDate;

  ScheduleLoaded({required this.selectedDate});
  @override
  List get props => [selectedDate];
}
