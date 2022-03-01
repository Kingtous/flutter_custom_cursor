
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterCustomCursor extends MouseCursor  {
  final String path;
  final double? x;
  final double? y;
  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
  const FlutterCustomCursor({
    required this.path,
    this.x,
    this.y
  });

  @override
  MouseCursorSession createSession(int device) => _FlutterDesktopCursorSession(this,device);

  @override
  String get debugDescription =>  '${objectRuntimeType(this, 'FlutterCustomCursor')}($path)';
}

class _FlutterDesktopCursorSession extends MouseCursorSession {
  _FlutterDesktopCursorSession(FlutterCustomCursor cursor, int device)
      : super(cursor, device);

  @override
  FlutterCustomCursor get cursor => super.cursor as FlutterCustomCursor;

  @override
  Future<void> activate() {
    return FlutterCustomCursor._channel.invokeMethod<void>(
      'activateCursor',
      <String, dynamic>{
        'device': device,
        'path': cursor.path,
        'x' : cursor.x,
        'y' : cursor.y,
      },
    );
  }

  @override
  void dispose() {/* Nothing */}
}