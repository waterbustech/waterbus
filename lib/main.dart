import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:universal_io/io.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/application.dart';
import 'package:waterbus/core/app/firebase_config.dart';
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/features/app/app.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

void main(List<String> args) async {
  usePathUrlStrategy();
  await runZonedGuarded(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(
        widgetsBinding: widgetsBinding,
      );

      PaintingBinding.instance.imageCache.maximumSizeBytes =
          1024 * 1024 * 300; // 300 MB

      await WaterbusSdk.instance.initializeApp(
        wsUrl: ApiEndpoints.wsUrl,
        apiUrl: ApiEndpoints.baseUrl,
      );

      if (!Platform.isLinux) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      await Application.initialAppLication();

      if (kIsWeb) {
        await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      }

      runApp(
        I18n(
          initialLocale: LanguageService().getLocale().locale,
          child: const App(),
        ),
      );

      if (WebRTC.platformIsMobile) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    },
    (error, stackTrace) {
      debugPrint(error.toString());

      if (!WebRTC.platformIsMobile) return;
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
