// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class AppSettings extends StatefulWidget {
  final Widget optionScreen;
  const AppSettings({
    super.key,
    required this.optionScreen,
  });

  @override
  State<StatefulWidget> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, theme) {
        return MaterialApp(
          navigatorKey: AppNavigator.navigatorSettingKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light().data,
          darkTheme: AppTheme.dark().data,
          themeMode: theme.props[0].theme,
          onGenerateRoute: AppNavigator().getRoute,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: Builder(
                builder: (context) {
                  SystemChrome.setSystemUIOverlayStyle(
                    Theme.of(context).appBarTheme.systemOverlayStyle!,
                  );
                  return child ?? const SizedBox();
                },
              ),
            );
          },
          home: widget.optionScreen,
        );
      },
    );
  }
}
