import 'package:auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import './auth_service_impl_stub.dart' as sub;
import './auth_service_impl_linux.dart' as linux;

bool get isLinux => !kIsWeb && Platform.isLinux;

AuthService get getInstance =>
    isLinux ? linux.AuthServiceImpl() : sub.AuthServiceImpl();
