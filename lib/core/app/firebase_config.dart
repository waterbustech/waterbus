// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    return null;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCg0POxwRZjYzVd4u571rkyObRdOHC3rvw",
    authDomain: "waterbus-71cf5.firebaseapp.com",
    projectId: "waterbus-71cf5",
    storageBucket: "waterbus-71cf5.appspot.com",
    messagingSenderId: "727554668212",
    appId: "1:727554668212:web:6624269d0494b187b989e1",
    measurementId: "G-3RWKDX1N14",
  );
}
