import 'android_permission_platform_interface.dart';

class AndroidPermission {
  Future<String?> checkPermissionGranted() {
    return AndroidPermissionPlatform.instance.checkPermissionGranted();
  }
}
