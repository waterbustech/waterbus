// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state_event.dart';
part 'app_state_state.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState> {
  AppStateBloc() : super(AppStateInitial()) {
    on<AppStateEvent>((event, emit) {});
  }
}
