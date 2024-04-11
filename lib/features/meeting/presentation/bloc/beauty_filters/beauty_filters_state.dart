part of 'beauty_filters_bloc.dart';

sealed class BeautyFiltersState extends Equatable {
  const BeautyFiltersState();

  @override
  List<Object> get props => [];
}

final class BeautyFiltersInitial extends BeautyFiltersState {}

class UpdatedBeautyFilters extends BeautyFiltersState {
  final BeautyFilters filters;
  const UpdatedBeautyFilters({required this.filters});
}
