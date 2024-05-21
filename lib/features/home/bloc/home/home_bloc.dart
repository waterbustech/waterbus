import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // MARK: variables
  int currentIndex = 0;

  HomeBloc() : super(HomeInitial(index: 0)) {
    on<HomeEvent>((event, emit) {
      if (event is OnChangeTabEvent) {
        _handleChangeTab(event);
        emit(_home);
      }
    });
  }

  // MARK: Private methods
  HomeInitial get _home => HomeInitial(index: currentIndex);

  void _handleChangeTab(OnChangeTabEvent event) {
    if (event.tabIndex == currentIndex) return;

    currentIndex = event.tabIndex;
  }
}
