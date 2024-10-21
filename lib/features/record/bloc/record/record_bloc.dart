import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';

import 'package:waterbus/core/helpers/file_saver.dart';

part 'record_event.dart';
part 'record_state.dart';

@injectable
class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  final List<RecordModel> _records = [];

  final FileSaverHelper _fileSaver;

  RecordBloc(this._fileSaver) : super(RecordInitial()) {
    on<RecordEvent>((event, emit) async {
      if (event is RefreshRecordsEvent) {
        _records.clear();
        await _getRecords();
        emit(_recordDone);
        event.handleFinish();
      }

      if (event is OnRecordsEvent) {
        if (_records.isNotEmpty) return;

        await _getRecords();
        emit(_recordDone);
      }

      if (event is GetRecordsEvent) {
        await _getRecords();
        emit(_recordDone);
      }

      if (event is SaveRecordFileEvent) {
        await _fileSaver.saveFile(event.record.urlToVideo);
      }
    });
  }

  GetRecordDone get _recordDone => GetRecordDone(records: _records);

  Future<void> _getRecords() async {
    final records = await _waterbusSdk.getRecords(skip: _records.length);

    if (records.isEmpty) return;

    _records.addAll(records);
  }
}
