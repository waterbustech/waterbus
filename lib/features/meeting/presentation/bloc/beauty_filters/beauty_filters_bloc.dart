// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/beauty_filters.dart';

part 'beauty_filters_event.dart';
part 'beauty_filters_state.dart';

@injectable
class BeautyFiltersBloc extends Bloc<BeautyFiltersEvent, BeautyFiltersState> {
  BeautyFilters _filters = BeautyFilters();

  BeautyFiltersBloc() : super(BeautyFiltersInitial()) {
    on<BeautyFiltersEvent>((event, emit) {
      if (event is UpdateFiltersValueEvent) {
        _adjustValue(event.filters);
        emit(_updatedFilters);
      }

      if (event is ResetFiltersValueEvent) {
        _adjustValue(BeautyFilters());
        emit(_updatedFilters);
      }
    });
  }

  // MARK: state
  UpdatedBeautyFilters get _updatedFilters => UpdatedBeautyFilters(
        filters: _filters,
      );

  // MARK: private
  void _adjustValue(BeautyFilters newValue) {
    if (_filters.smoothValue != newValue.smoothValue) {
      Helper.setSmoothValue(newValue.smoothValue);
    }
    if (_filters.whiteValue != newValue.whiteValue) {
      Helper.setWhiteValue(newValue.whiteValue);
    }
    if (_filters.bigEyeValue != newValue.bigEyeValue) {
      Helper.setBigEyeValue(newValue.bigEyeValue);
    }
    if (_filters.thinFaceValue != newValue.thinFaceValue) {
      Helper.setThinFaceValue(newValue.thinFaceValue);
    }
    if (_filters.lipstickValue != newValue.lipstickValue) {
      Helper.setLipstickValue(newValue.lipstickValue);
    }
    if (_filters.blusherValue != newValue.blusherValue) {
      Helper.setBlusherValue(newValue.blusherValue);
    }

    _filters = newValue.copyWith();
  }

  // MARK: public state
  BeautyFilters get filters => _filters.copyWith();
}
