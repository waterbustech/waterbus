import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';

import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/socket/socket_chat_handle.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    getIt<SocketChatHandle>().onListenSocket();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return BlocBuilder<ThemesBloc, ThemesState>(
            builder: (context, stateThemes) {
              return MaterialApp(
                title: kAppTitle,
                navigatorKey: AppNavigator.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light().data,
                darkTheme: AppTheme.dark().data,
                themeMode: stateThemes.props[0].theme,
                initialRoute: Routes.rootRoute,
                navigatorObservers: [
                  AppNavigatorObserver(),
                  NavigatorObserver(),
                ],
                onGenerateRoute: (settings) {
                  return AppNavigator().getRoute(settings);
                },
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
              );
            },
          );
        },
      ),
    );
  }
}
