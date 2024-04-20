// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            navigatorKey: AppNavigator.navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: AppTheme.light().data,
            darkTheme: AppTheme.dark().data,
            initialRoute: Routes.rootRoute,
            navigatorObservers: [
              NavigatorObserver(),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportLanguages,
            onGenerateRoute: (settings) {
              return AppNavigator().getRoute(settings);
            },
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child ?? const SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
