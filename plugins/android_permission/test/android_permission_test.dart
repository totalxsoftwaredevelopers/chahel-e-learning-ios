import 'package:flutter_test/flutter_test.dart';
import 'package:android_permission/android_permission.dart';
import 'package:android_permission/android_permission_platform_interface.dart';
import 'package:android_permission/android_permission_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAndroidPermissionPlatform
    with MockPlatformInterfaceMixin
    implements AndroidPermissionPlatform {
  @override
  Future<String?> checkPermissionGranted() => Future.value('42');
}

void main() {
  final AndroidPermissionPlatform initialPlatform =
      AndroidPermissionPlatform.instance;

  test('$MethodChannelAndroidPermission is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAndroidPermission>());
  });

  test('getPlatformVersion', () async {
    AndroidPermission androidPermissionPlugin = AndroidPermission();
    MockAndroidPermissionPlatform fakePlatform =
        MockAndroidPermissionPlatform();
    AndroidPermissionPlatform.instance = fakePlatform;

    expect(await androidPermissionPlugin.checkPermissionGranted(), '42');
  });
}
