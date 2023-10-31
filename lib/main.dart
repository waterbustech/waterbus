// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/app/application.dart';
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/features/app/app.dart';

void main(List<String> args) async {
  await runZonedGuarded(() async {
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(
      widgetsBinding: widgetsBinding,
    );

    PaintingBinding.instance.imageCache.maximumSizeBytes =
        1024 * 1024 * 300; // 300 MB

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    await Future.wait([
      Application.initialAppLication(),
      Firebase.initializeApp(),
    ]);

    WaterbusSdk.instance.initial(waterbusUrl: ApiEndpoints.wsUrl);

    runApp(const App());

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
