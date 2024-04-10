// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/app/themes/theme_services.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeMode currentThemeMode = ThemeMode.light;

  ThemeBloc() : super(InitialThemeState()) {
    on<ThemeEvent>(
      (event, emit) async {
        if (event is InitialTheme) {
          currentThemeMode = ThemeService().getThemeMode();

          ThemeService().changeThemeMode(mode: currentThemeMode);
          emit(ThemeUpdated(mode: currentThemeMode));
        }

        if (event is OnChangeTheme) {
          currentThemeMode = event.themeMode ?? ThemeMode.light;

          ThemeService().changeThemeMode(mode: currentThemeMode);
          emit(ThemeUpdated(mode: currentThemeMode));
        }
      },
    );
  }
}
