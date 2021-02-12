
import 'dart:async';

import 'package:flutter/services.dart';

class Midtrans {
  static const MethodChannel _channel =
      const MethodChannel('midtrans');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
