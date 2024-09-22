import 'package:flutter/material.dart';

import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/core/utils/datasources/base_local_data.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';

class Application {
  /// [Production - Dev]
  static Future<void> initialAppLication() async {
    try {
      // Config local storage
      await BaseLocalData.initialBox();

      configureDependencies();

      AppBloc.authBloc.add(OnAuthCheckEvent());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
