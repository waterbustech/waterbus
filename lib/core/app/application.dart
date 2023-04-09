// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/injection/injection_container.dart';

class Application {
  /// [Production - Dev]
  static Future<void> initialAppLication() async {
    try {
      // Init dependency injection
      configureDependencies();
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
