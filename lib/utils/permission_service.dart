import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> intialize() async {
    // var notificationPermission = Permission.notification.status;
    // if (await notificationPermission.isDenied) {
    //   Permission.notification.request();
    // } else if (await notificationPermission.isPermanentlyDenied) {
    //   openAppSettings();
    // }
    final PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      // Notification permission granted
      if (kDebugMode) {
        print('Notification permission granted');
      }
    } else if (status.isDenied) {
      // Notification permission denied
      if (kDebugMode) {
        print('Notification permission denied');
      }
      await Permission.notification.request();
      // await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // Notification permission permanently denied, open app settings
      await openAppSettings();
    }
  }
}
