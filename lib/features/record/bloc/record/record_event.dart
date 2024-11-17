part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class RecordsStarted extends RecordEvent {}

class RecordsGet extends RecordEvent {}

class RecordsSave extends RecordEvent {
  final RecordModel record;
  const RecordsSave({required this.record});
}

class RecordsRefresh extends RecordEvent {
  final Function handleFinish;
  const RecordsRefresh(this.handleFinish);
}
