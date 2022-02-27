
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCustomCursor {
  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
