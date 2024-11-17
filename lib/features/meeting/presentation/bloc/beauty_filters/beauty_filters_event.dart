part of 'beauty_filters_bloc.dart';

sealed class BeautyFiltersEvent extends Equatable {
  const BeautyFiltersEvent();

  @override
  List<Object> get props => [];
}

class BeautyFilterUpdate extends BeautyFiltersEvent {
  final BeautyFilters filters;
  const BeautyFilterUpdate({required this.filters});
}

class BeautyFilterReset extends BeautyFiltersEvent {}
