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
  // for windows

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
        // debugPrint("has cache, ignore buffer");
        buffer = Platform.isWindows ? Uint8List(0) : null;
      }
      if (!await customCursorController.needUpdateCursor(cursor.key)) {
        // no need to update
        //  debugPrint("no need to update");
        return;
      }
      if (cursor.key != null && cursor.key!.isNotEmpty) {
        customCursorController.addCache(cursor.key!);
    }
    if (Platform.isWindows && cursor.key != null && await FlutterCustomCursorController.instance.lastCursorKey() == cursor.key) {
      // debugPrint("no need to update");
      return;
    }
    final param = <String, dynamic>{
      'device': device,
      'key': cursor.key ?? "",
      'buffer': buffer,
      'length': buffer?.length ?? -1,
      'x': cursor.hotx ?? 0.0,
      'y': cursor.hoty ?? 0.0,
      'scale_x': cursor.imageWidth ?? -1,
      'scale_y': cursor.imageHeight ?? -1
    };
    if (Platform.isWindows) {
      // print("set cursor");
      return await SystemChannels.mouseCursor.invokeMethod<void>(
        'setSystemCursor',
        param,
      );
    } else {
      return await FlutterCustomMemoryImageCursor._channel.invokeMethod<void>(
        'activateMemoryImageCursor',
        param,
      );
    }
  }

  @override
  void dispose() {}
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
      // debugPrint("dummy dispose");
    }
  }
}

typedef NeedUpdateCursorCallback = Future<bool> Function(
    String? lastKey, String? currentKey);

class FlutterCustomCursorController {
  FlutterCustomCursorController._();

  static FlutterCustomCursorController instance =
      FlutterCustomCursorController._();

  static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
  List<String> cached = List.empty(growable: true);
  List<NeedUpdateCursorCallback> callbacks = [];
  String _lastCursorKey = "";

  Future<void> freeCache(String key) async {
    if (Platform.isWindows) {
      await SystemChannels.mouseCursor
          .invokeMethod("freeCache", <String, dynamic>{"key": key});
    } else if (Platform.isLinux) {
      await _channel.invokeMethod("freeCache", <String, dynamic>{"key": key});
    } else {
      // todo: macos
    }
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
    _lastCursorKey = key;
  }

  Future<String?> lastCursorKey() async {
    if (Platform.isWindows) {
      return SystemChannels.mouseCursor.invokeMethod("lastCursorKey");
    } else {
      return _channel.invokeMethod("lastCursorKey");
    }
  }

  Future<List<String>?> getCursorCacheKey() async {
    if (Platform.isWindows) {
      final keys = await SystemChannels.mouseCursor.invokeMethod<List<Object?>>("getCacheKeyList");
      return keys?.map((e) => e.toString()).toList(growable: false);
    } else {
      final keys = await _channel.invokeMethod<List<Object?>>("getCacheKeyList");
      return keys?.map((e) => e.toString()).toList(growable: false);
    }
  }

  void registerNeedUpdateCursorCallback(NeedUpdateCursorCallback callback) {
    if (callbacks.contains(callback)) {
      return;
    }
    callbacks.add(callback);
  }

  void remoteNeedUpdateCursorCallback(NeedUpdateCursorCallback callback) {
    callbacks.remove(callback);
  }

  /// if one need update cursor, so let's update
  Future<bool> needUpdateCursor(String? currentKey) async {
    if (callbacks.isEmpty) {
      // no registered callback, default is true
      return true;
    }
    final lastKey = await lastCursorKey();
    for (final cb in callbacks) {
      bool needUpdate = await cb.call(lastKey, currentKey);
      if (needUpdate) {
        return true;
      }
    }
    return false;
  }
}

final customCursorController = FlutterCustomCursorController.instance;
