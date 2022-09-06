import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterCustomCursor extends MouseCursor {
  final String path;
  final double? x;
  final double? y;
  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
  const FlutterCustomCursor({required this.path, this.x, this.y});

  @override
  MouseCursorSession createSession(int device) =>
      _FlutterDesktopCursorSession(this, device);

  @override
  String get debugDescription =>
      '${objectRuntimeType(this, 'FlutterCustomCursor')}($path)';
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
        'x': cursor.x ?? 0.0,
        'y': cursor.y ?? 0.0,
      },
    );
  }

  @override
  void dispose() {/* Nothing */}
}

class FlutterCustomMemoryImageCursor extends MouseCursor {
  final Uint8List pixbuf;
  final double? hotx;
  final double? hoty;
  // can used to scale image, can be null
  final int? imageWidth;
  final int? imageHeight;

  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
  const FlutterCustomMemoryImageCursor(
      {required this.pixbuf,
      this.hotx,
      this.hoty,
      this.imageHeight,
      this.imageWidth});

  @override
  MouseCursorSession createSession(int device) =>
      _FlutterCustomMemoryImageCursorSession(this, device);

  @override
  String get debugDescription =>
      '${objectRuntimeType(this, 'FlutterCustomMemoryImageCursor')}(${pixbuf.length})';
}

class _FlutterCustomMemoryImageCursorSession extends MouseCursorSession {
  _FlutterCustomMemoryImageCursorSession(
      FlutterCustomMemoryImageCursor cursor, int device)
      : super(cursor, device);

  @override
  FlutterCustomMemoryImageCursor get cursor =>
      super.cursor as FlutterCustomMemoryImageCursor;

  @override
  Future<void> activate() {
    return FlutterCustomMemoryImageCursor._channel.invokeMethod<void>(
      'activateMemoryImageCursor',
      <String, dynamic>{
        'device': device,
        'buffer': cursor.pixbuf,
        'length': cursor.pixbuf.length,
        'x': cursor.hotx ?? 0.0,
        'y': cursor.hoty ?? 0.0,
        'scale_x': cursor.imageWidth ?? -1,
        'scale_y': cursor.imageHeight ?? -1
      },
    );
  }

  @override
  void dispose() {/* Nothing */}
}
