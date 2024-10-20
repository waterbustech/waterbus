part of 'record_bloc.dart';

sealed class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

final class RecordInitial extends RecordState {}

class GetRecordDone extends RecordState {
  final List<RecordModel> records;
  const GetRecordDone({required this.records});
}
