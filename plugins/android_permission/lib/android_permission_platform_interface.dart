import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_permission_method_channel.dart';

abstract class AndroidPermissionPlatform extends PlatformInterface {
  /// Constructs a AndroidPermissionPlatform.
  AndroidPermissionPlatform() : super(token: _token);

  static final Object _token = Object();

  static AndroidPermissionPlatform _instance = MethodChannelAndroidPermission();

  /// The default instance of [AndroidPermissionPlatform] to use.
  ///
  /// Defaults to [MethodChannelAndroidPermission].
  static AndroidPermissionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AndroidPermissionPlatform] when
  /// they register themselves.
  static set instance(AndroidPermissionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> checkPermissionGranted() {
    throw UnimplementedError(
        'checkPermissionGranted() has not been implemented.');
  }
}
