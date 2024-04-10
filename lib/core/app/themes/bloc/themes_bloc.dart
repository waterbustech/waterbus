// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/app/datasource/settings_manager_datasource.dart';
import 'package:waterbus/core/app/themes/app_theme.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/app/themes/theme_services.dart';

part 'themes_event.dart';
part 'themes_state.dart';

@injectable
class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  final SettingsManagerDatasource _settingsManagerDatasource;

  ThemesBloc(this._settingsManagerDatasource)
      : super(
          ThemesStateInitial(
            appTheme: ThemeService().getTheme(),
          ),
        ) {
    on<ThemesEvent>((event, emit) {
      if (event is OnChangeTheme) {
        _handleChangeThemes(event);
        emit(_theme);
      }
    });
  }
  ThemesStateInitial get _theme =>
      ThemesStateInitial(appTheme: ThemeService().getTheme());

  void _handleChangeThemes(OnChangeTheme event) {
    _settingsManagerDatasource.setTheme(
      appTheme:
          event.appTheme == ThemeList.dark ? ThemeList.light : ThemeList.dark,
    );
  }
}
