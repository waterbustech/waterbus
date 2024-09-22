import 'package:permission_handler/permission_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class WaterbusPermissionHandler {
  void handleStatusPermission({
    PermissionStatus? status,
    Function? onPermissionAccepted,
    Function? onPermissionDenied,
  }) {
    switch (status) {
      case PermissionStatus.granted:
        onPermissionAccepted!();
        break;
      case PermissionStatus.permanentlyDenied:
        onPermissionDenied!();
        break;
      default:
        onPermissionDenied!();
        break;
    }
  }

  Future<void> checkGrantedForExecute({
    required List<Permission> permissions,
    required Future<void> Function() callBack,
  }) async {
    if (!WebRTC.platformIsMobile) {
      await callBack();
      return;
    }

    final List<bool> isGranteds = [];

    for (final permission in permissions) {
      PermissionStatus status = await permission.request();

      if (status == PermissionStatus.denied) {
        status = await permission.request();
      } else if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }

      if (status.isGranted) {
        isGranteds.add(true);
      }
    }

    // Check passed all and execute callback
    if (isGranteds.length == permissions.length) {
      await callBack();
    }
  }
}
