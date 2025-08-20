import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/app/themes/preset.dart';
import 'package:waterbus/features/settings/data/datasource/themes_local_data_source.dart';

part 'themes_event.dart';
part 'themes_state.dart';

@injectable
class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  final ThemesLocalDataSource _themesLocalDataSource;

  ThemesBloc(this._themesLocalDataSource)
      : super(ThemesStateInitial(preset: _themesLocalDataSource.getTheme())) {
    on<ThemesEvent>((event, emit) {
      if (event is ThemeChanged) {
        _handleThemeChanged(event);
        emit(_theme);
      }
    });
  }

  ThemesStateInitial get _theme =>
      ThemesStateInitial(preset: _themesLocalDataSource.getTheme());

  void _handleThemeChanged(ThemeChanged event) {
    _themesLocalDataSource.setTheme(presetName: event.preset.name);
  }
}
