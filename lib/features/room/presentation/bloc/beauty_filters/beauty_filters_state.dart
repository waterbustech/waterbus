part of 'beauty_filters_bloc.dart';

sealed class BeautyFiltersState extends Equatable {
  const BeautyFiltersState();

  @override
  List<Object> get props => [];
}

final class BeautyFiltersInitial extends BeautyFiltersState {}

class BeautyFiltersUpdated extends BeautyFiltersState {
  final BeautyFilters filters;
  const BeautyFiltersUpdated({required this.filters});
}
