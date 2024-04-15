// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/settings/themes/data/themes_datasource.dart';

part 'themes_event.dart';
part 'themes_state.dart';

@injectable
class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  final ThemesDatasource _themesDatasource;
  ThemesBloc(this._themesDatasource)
      : super(
          ThemesStateInitial(
            appTheme: _themesDatasource.getTheme(),
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
      ThemesStateInitial(appTheme: _themesDatasource.getTheme());

  void _handleChangeThemes(OnChangeTheme event) {
    late String appTheme;
    switch (event.appTheme) {
      case ThemeList.dark:
        appTheme = ThemeList.light;
        break;
      case ThemeList.light:
        appTheme = ThemeList.dark;
        break;
      default:
        appTheme = ThemeList.dark;
        break;
    }
    _themesDatasource.setTheme(appTheme: appTheme);
  }
}
