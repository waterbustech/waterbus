part of 'beauty_filters_bloc.dart';

sealed class BeautyFiltersEvent extends Equatable {
  const BeautyFiltersEvent();

  @override
  List<Object> get props => [];
}

class BeautyFilterUpdated extends BeautyFiltersEvent {
  final BeautyFilters filters;
  const BeautyFilterUpdated({required this.filters});
}

class BeautyFilterReset extends BeautyFiltersEvent {}
