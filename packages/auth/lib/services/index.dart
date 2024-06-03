import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

export './auth_service_impl_stub.dart'
    if (isLinux) './auth_service_impl_linux.dart';

bool get isLinux => !kIsWeb && Platform.isLinux;
