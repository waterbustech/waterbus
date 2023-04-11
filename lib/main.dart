// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:waterbus/core/app/application.dart';
import 'package:waterbus/features/app/app.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      1024 * 1024 * 300; // 300 MB
  await runZonedGuarded(() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),);
    await Application.initialAppLication();

    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      MultiBlocProvider(
        providers: AppBloc.providers,
        child: const App(),
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
