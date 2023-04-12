part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleEvent {}

class SeleteDateEvent extends ScheduleEvent {
  final DateTime date;

  SeleteDateEvent({required this.date});
}

class NextMonthEvent extends ScheduleEvent {}

class PreviousMonthEvent extends ScheduleEvent {}
