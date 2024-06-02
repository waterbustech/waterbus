import 'dart:io' show Platform;

import 'package:auth/services/auth_service.dart';
import 'package:auth/services/auth_service_impl_linux.dart' as linux;
import 'package:auth/services/auth_service_impl_stub.dart' as stub;

AuthService getAuthService() {
  if (Platform.isLinux) {
    return linux.AuthServiceImpl();
  } else {
    return stub.AuthServiceImpl();
  }
}
