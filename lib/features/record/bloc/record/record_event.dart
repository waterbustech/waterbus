part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class RecordsStarted extends RecordEvent {}

class RecordsFetched extends RecordEvent {}

class RecordsSaved extends RecordEvent {
  final RecordModel record;
  const RecordsSaved({required this.record});
}

class RecordsRefreshed extends RecordEvent {
  final Function handleFinish;
  const RecordsRefreshed(this.handleFinish);
}
