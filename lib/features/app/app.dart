import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:toastification/toastification.dart';

import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/app/themes/preset.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/size_not_supported.dart';
import 'package:waterbus/features/settings/presentation/bloc/themes/themes_bloc.dart';

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
        builder: (context, sizerExtension) {
          return BlocBuilder<ThemesBloc, ThemesState>(
            builder: (context, theme) {
              return ToastificationWrapper(
                child: MaterialApp.router(
                  routerConfig: AppRouter.instance.router,
                  title: kAppTitle,
                  locale: I18n.locale,
                  supportedLocales: I18n.supportedLocales,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.fromPreset(
                    theme is ThemesStateInitial
                        ? theme.preset
                        : Preset.tokyoNight,
                    extensions: [sizerExtension],
                  ).data,
                  themeMode: ThemeMode.dark,
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

                          return SizeNotSupportedWidget(
                            child: SafeArea(
                              top: false,
                              bottom: false,
                              child: GestureDetector(
                                onTap: () {
                                  if (_isKeyboardVisible) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                                child: child ?? const SizedBox(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool get _isKeyboardVisible =>
      FocusManager.instance.primaryFocus?.hasFocus ?? false;
}
