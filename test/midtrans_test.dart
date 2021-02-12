import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midtrans/midtrans.dart';

void main() {
  const MethodChannel channel = MethodChannel('midtrans');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Midtrans.platformVersion, '42');
  });
}
