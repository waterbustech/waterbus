import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/constants/constants.dart';
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
          title: kAppTitle,
          navigatorKey: AppNavigator.navigatorSettingKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(colorSeed: theme.props.last).data,
          darkTheme: AppTheme.dark(colorSeed: theme.props.last).data,
          themeMode: theme.props.first,
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
