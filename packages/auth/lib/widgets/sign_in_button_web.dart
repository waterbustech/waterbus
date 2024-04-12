// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

Widget signInButton() {
  return (GoogleSignInPlatform.instance as web.GoogleSignInPlugin).renderButton(
    configuration: web.GSIButtonConfiguration(
      minimumWidth: 320,
      size: web.GSIButtonSize.large,
      shape: web.GSIButtonShape.rectangular,
      logoAlignment: web.GSIButtonLogoAlignment.left,
      theme: web.GSIButtonTheme.outline,
      text: web.GSIButtonText.continueWith,
      locale: 'en',
    ),
  );
}
