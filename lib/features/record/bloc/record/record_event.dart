part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class OnRecordsEvent extends RecordEvent {}

class GetRecordsEvent extends RecordEvent {}

class SaveRecordFileEvent extends RecordEvent {
  final RecordModel record;
  const SaveRecordFileEvent({required this.record});
}
