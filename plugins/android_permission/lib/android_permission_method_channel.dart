import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'android_permission_platform_interface.dart';

/// An implementation of [AndroidPermissionPlatform] that uses method channels.
class MethodChannelAndroidPermission extends AndroidPermissionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('android_permission');

  @override
  Future<String?> checkPermissionGranted() async {
    final version = await methodChannel.invokeMethod<String>(
        'checkPermissionGranted', {'parameter': 'READ_MEDIA_VIDEO'});
    print(version);
    return version;
  }
}
