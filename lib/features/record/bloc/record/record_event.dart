part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class RefreshRecordsEvent extends RecordEvent {
  final Function handleFinish;
  const RefreshRecordsEvent(this.handleFinish);
}

class OnRecordsEvent extends RecordEvent {}

class GetRecordsEvent extends RecordEvent {}

class SaveRecordFileEvent extends RecordEvent {
  final RecordModel record;
  const SaveRecordFileEvent({required this.record});
}
