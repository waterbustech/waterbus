part of 'logger_bloc.dart';

sealed class LoggerState extends Equatable {
  final List<LogRecord> records;
  const LoggerState({required this.records});

  @override
  List<Object> get props => [[]];
}

final class LoggerInitial extends LoggerState {
  const LoggerInitial({super.records = const []});
}

final class LoggerLoading extends LoggerState {
  const LoggerLoading({required super.records});
}

final class LoggerLoaded extends LoggerState {
  const LoggerLoaded({required super.records});
}
