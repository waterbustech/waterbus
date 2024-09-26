import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/constants/constants.dart';

part 'select_color_event.dart';
part 'select_color_state.dart';

class SelectColorBloc extends Bloc<SelectColorEvent, SelectColorState> {
  SelectColorBloc() : super(SelectColorInitial()) {
    on<SelectColorEvent>((event, emit) {
      if (event is ChangeColorEvent) {
        emit(ChangeColorState(event.color));
      }
    });
  }
}
