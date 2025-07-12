import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/application.dart';
import 'package:waterbus/core/constants/endpoints.dart';
import 'package:waterbus/core/utils/image_utils.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/features/app/app.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';
import 'package:waterbus/firebase_options.dart';

void main(List<String> args) async {
  usePathUrlStrategy();
  await runZoned(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      GoRouter.optionURLReflectsImperativeAPIs = true;

      final List<Future> futures = [
        ImageUtils().init(),
        WaterbusSdk.instance.initialize(
          config: SdkConfig(
            serverConfig: ServerConfig(
              url: Endpoints.baseUrl,
              suffixUrl: Endpoints.suffixUrl,
            ),
          ),
        ),
      ];

      if (kIsWeb || !(PlatformUtils.isLinux || PlatformUtils.isWindows)) {
        futures.add(
          Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
        );
      }

      await Future.wait(futures);

      await Application.initialAppLication();

      if (kIsWeb) {
        await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      }

      runApp(
        I18n(
          autoSaveLocale: true,
          initialLocale: LanguageService().getLocale().locale,
          supportedLocales: ['en-US'.asLocale, 'vi-VN'.asLocale],
          child: const App(),
        ),
      );

      if (WebRTC.platformIsMobile) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    },
  );
}
