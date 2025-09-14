import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

part 'logger_event.dart';
part 'logger_state.dart';

@injectable
class LoggerBloc extends Bloc<LoggerEvent, LoggerState> {
  final List<LogRecord> _logs = [];
  final Logger _rootLogger = Logger.root;

  LoggerBloc() : super(LoggerInitial()) {
    on<LoggerEvent>((event, emit) {
      if (event is LoggerInitialEvent) {
        _rootLogger.level = Level.ALL;
        _rootLogger.onRecord.listen((record) {
          _logs.add(record);
          add(LoggerUpdateEvent());
        });
      }

      if (event is LoggerUpdateEvent) {
        emit(_loading);
        emit(_loaded);
      }

      if (event is LoggerClearEvent) {
        emit(_loading);
        _logs.clear();
        emit(_loaded);
      }
    });
  }

  // Getters
  LoggerLoading get _loading => LoggerLoading(records: _logs);
  LoggerLoaded get _loaded => LoggerLoaded(records: _logs);
}
