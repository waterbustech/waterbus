// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: AppTheme.light().data,
          darkTheme: AppTheme.dark().data,
          navigatorObservers: [
            NavigatorObserver(),
          ],
          onGenerateRoute: (settings) {
            return AppNavigator().getRoute(settings);
          },
        );
      },
    );
  }
}
