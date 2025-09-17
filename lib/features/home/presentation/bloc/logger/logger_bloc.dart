import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'package:waterbus/features/home/domain/entities/log_record_extension.dart';

part 'logger_event.dart';
part 'logger_state.dart';

@injectable
class LoggerBloc extends Bloc<LoggerEvent, LoggerState> {
  final List<LogRecord> _logs = [];
  final Logger _rootLogger = Logger.root;

  String _keyword = '';
  Level? _loggerLevel;

  LoggerBloc() : super(LoggerInitial()) {
    on<LoggerEvent>((event, emit) {
      if (event is LoggerInitialEvent) {
        _rootLogger.level = Level.ALL;
        _rootLogger.onRecord.listen((record) {
          _logs.add(record);
          add(LoggerUpdateEvent());
        });
      }

      if (event is LoggerFilterEvent) {
        _keyword = event.keyword;
        _loggerLevel = event.level;

        add(LoggerUpdateEvent());
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

  // Privates
  List<LogRecord> get _filterLoggerList {
    final List<LogRecord> logFilters = List.from(_logs);
    if (_keyword.isNotEmpty) {
      logFilters.removeWhere((item) => !item.label.contains(_keyword));
    }

    if (_loggerLevel != null) {
      logFilters.removeWhere((item) => item.level != _loggerLevel);
    }

    return logFilters;
  }

  // Getters
  LoggerLoading get _loading => LoggerLoading(records: _filterLoggerList);
  LoggerLoaded get _loaded => LoggerLoaded(records: _filterLoggerList);
  String get keyword => _keyword;
  Level? get level => _loggerLevel;
}
