import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class HomeAppScreen extends StatefulWidget {
  final Widget homeScreen;
  const HomeAppScreen({
    super.key,
    required this.homeScreen,
  });

  @override
  State<StatefulWidget> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, theme) {
        return MaterialApp(
          navigatorKey: AppNavigator.navigatorHomeKey,
          debugShowCheckedModeBanner: false,
          title: kAppTitle,
          locale: LanguageService().getLocale().locale,
          supportedLocales: LanguageService.supportLanguages,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light(colorSeed: theme.props.last).data,
          darkTheme: AppTheme.dark(colorSeed: theme.props.last).data,
          themeMode: theme.props.first,
          onGenerateRoute: AppNavigator().getRoute,
          navigatorObservers: [
            AppNavigatorObserver(),
            NavigatorObserver(),
          ],
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
          home: widget.homeScreen,
        );
      },
    );
  }
}
