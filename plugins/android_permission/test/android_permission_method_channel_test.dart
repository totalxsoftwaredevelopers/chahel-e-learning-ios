import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_permission/android_permission_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAndroidPermission platform = MethodChannelAndroidPermission();
  const MethodChannel channel = MethodChannel('android_permission');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.checkPermissionGranted(), '42');
  });
}
