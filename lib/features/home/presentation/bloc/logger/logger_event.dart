part of 'logger_bloc.dart';

sealed class LoggerEvent extends Equatable {
  const LoggerEvent();

  @override
  List<Object> get props => [];
}

final class LoggerInitialEvent extends LoggerEvent {}

final class LoggerUpdateEvent extends LoggerEvent {}

final class LoggerClearEvent extends LoggerEvent {}
