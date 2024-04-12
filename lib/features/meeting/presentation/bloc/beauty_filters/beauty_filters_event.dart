part of 'beauty_filters_bloc.dart';

sealed class BeautyFiltersEvent extends Equatable {
  const BeautyFiltersEvent();

  @override
  List<Object> get props => [];
}

class UpdateFiltersValueEvent extends BeautyFiltersEvent {
  final BeautyFilters filters;
  const UpdateFiltersValueEvent({required this.filters});
}

class ResetFiltersValueEvent extends BeautyFiltersEvent {}
