import 'dart:async';
import 'dart:io';
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
  final String? key;
  final Uint8List? pixbuf;
  final double? hotx;
  final double? hoty;
  // can used to scale image, can be null
  final int? imageWidth;
  final int? imageHeight;

  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
  const FlutterCustomMemoryImageCursor(
      {this.pixbuf,
      this.key,
      this.hotx,
      this.hoty,
      this.imageHeight,
      this.imageWidth})
      : assert((key != null && key != "") || pixbuf != null);

  @override
  MouseCursorSession createSession(int device) =>
      _FlutterCustomMemoryImageCursorSession(this, device);

  @override
  String get debugDescription =>
      '${objectRuntimeType(this, 'FlutterCustomMemoryImageCursor')}(${pixbuf?.length})';
}

class _FlutterCustomMemoryImageCursorSession extends MouseCursorSession {
  _FlutterCustomMemoryImageCursorSession(
      FlutterCustomMemoryImageCursor cursor, int device)
      : super(cursor, device);

  @override
  FlutterCustomMemoryImageCursor get cursor =>
      super.cursor as FlutterCustomMemoryImageCursor;

  @override
  Future<void> activate() async {
    Uint8List? buffer = cursor.pixbuf;
    if (cursor.key != null &&
        cursor.key!.isNotEmpty &&
        customCursorController.hasCache(cursor.key!)) {
      // has cache, ignore buffer
      buffer = null;
    }
    await FlutterCustomMemoryImageCursor._channel.invokeMethod<void>(
      'activateMemoryImageCursor',
      <String, dynamic>{
        'device': device,
        'key': cursor.key ?? "",
        'buffer': buffer,
        'length': buffer?.length ?? -1,
        'x': cursor.hotx ?? 0.0,
        'y': cursor.hoty ?? 0.0,
        'scale_x': cursor.imageWidth ?? -1,
        'scale_y': cursor.imageHeight ?? -1
      },
    );
    if (cursor.key != null && cursor.key!.isNotEmpty) {
      customCursorController.addCache(cursor.key!);
    }
  }

  @override
  void dispose() {
    if (Platform.isWindows) {
      debugPrint("activateMemoryImageCursor dispose");
      DummyCursor._flutterChannel.invokeMapMethod(
          "activateSystemCursor", <String, dynamic>{"kind": "text"});
      FlutterCustomMemoryImageCursor._channel.invokeMethod<void>(
        'dispose',
        <String, dynamic>{},
      );
    }
  }
}

class DummyCursor extends MouseCursor {
  const DummyCursor();

  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');

  static const MethodChannel _flutterChannel =
      MethodChannel('flutter/mousecursor');

  @override
  MouseCursorSession createSession(int device) => _DummySession(this, device);

  @override
  String get debugDescription =>
      '${objectRuntimeType(this, 'FlutterCustomMemoryImageCursor')}';
}

class _DummySession extends MouseCursorSession {
  _DummySession(DummyCursor cursor, int device) : super(cursor, device);

  @override
  DummyCursor get cursor => super.cursor as DummyCursor;

  @override
  Future<void> activate() {
    return Future.value();
  }

  @override
  void dispose() {
    if (Platform.isWindows) {
      debugPrint("dummy dispose");
    }
  }
}

class FlutterCustomCursorController {
  FlutterCustomCursorController._();

  static FlutterCustomCursorController instance =
      FlutterCustomCursorController._();

  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');

  static List<String> cached = List.empty(growable: true);

  Future<void> freeCache(String key) async {
    await _channel.invokeMethod("freeCache", <String, dynamic>{"key": key});
    cached.remove(key);
  }

  bool hasCache(String? key) {
    if (key == null) {
      return false;
    }
    return cached.contains(key);
  }

  void addCache(String? key) {
    if (key == null) {
      return;
    }
    if (!cached.contains(key)) {
      cached.add(key);
    }
  }
}

final customCursorController = FlutterCustomCursorController.instance;
