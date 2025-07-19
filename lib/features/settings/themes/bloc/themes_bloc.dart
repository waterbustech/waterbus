import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/features/settings/themes/data/themes_datasource.dart';

part 'themes_event.dart';
part 'themes_state.dart';

@injectable
class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  final ThemesDatasource _themesLocal;

  ThemesBloc(this._themesLocal)
      : super(
          ThemesStateInitial(mode: _themesLocal.getTheme()),
        ) {
    on<ThemesEvent>((event, emit) {
      if (event is ThemeChanged) {
        _handleThemeChanged(event);
        emit(_theme);
      }
    });
  }

  ThemesStateInitial get _theme => ThemesStateInitial(
        mode: _themesLocal.getTheme(),
      );

  void _handleThemeChanged(ThemeChanged event) {
    _themesLocal.setTheme(themeMode: event.mode.name);
  }
}
