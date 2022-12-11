import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_cursor/cursor_manager.dart';

class FlutterCustomMemoryImageCursor extends MouseCursor {
  final String? key;
  const FlutterCustomMemoryImageCursor({this.key})
      : assert((key != null && key != ""));

  @override
  MouseCursorSession createSession(int device) =>
      _FlutterCustomMemoryImageCursorSession(this, device);

  @override
  String get debugDescription =>
      objectRuntimeType(this, 'FlutterCustomMemoryImageCursor');
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
    await CursorManager.instance.setSystemCursor(cursor.key.toString());
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
      objectRuntimeType(this, 'FlutterCustomMemoryImageCursor');
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
  void dispose() {}
}

// typedef NeedUpdateCursorCallback = Future<bool> Function(
//     String? lastKey, String? currentKey);

// class FlutterCustomCursorController {
//   FlutterCustomCursorController._();

//   static FlutterCustomCursorController instance =
//       FlutterCustomCursorController._();

//   static const MethodChannel _channel = MethodChannel('flutter_custom_cursor');
//   List<String> cached = List.empty(growable: true);
//   List<NeedUpdateCursorCallback> callbacks = [];
//   String _lastCursorKey = "";

//   Future<void> freeCache(String key) async {
//     if (Platform.isWindows) {
//       await SystemChannels.mouseCursor
//           .invokeMethod("freeCache", <String, dynamic>{"key": key});
//     } else if (Platform.isLinux) {
//       await _channel.invokeMethod("freeCache", <String, dynamic>{"key": key});
//     } else {
//       // todo: macos
//     }
//     cached.remove(key);
//   }

//   bool hasCache(String? key) {
//     if (key == null) {
//       return false;
//     }
//     return cached.contains(key);
//   }

//   void addCache(String? key) {
//     if (key == null) {
//       return;
//     }
//     if (!cached.contains(key)) {
//       cached.add(key);
//     }
//     _lastCursorKey = key;
//   }

//   Future<String?> lastCursorKey() async {
//     if (Platform.isWindows) {
//       return SystemChannels.mouseCursor.invokeMethod("lastCursorKey");
//     } else {
//       return _channel.invokeMethod("lastCursorKey");
//     }
//   }

//   Future<List<String>?> getCursorCacheKey() async {
//     if (Platform.isWindows) {
//       final keys = await SystemChannels.mouseCursor
//           .invokeMethod<List<Object?>>("getCacheKeyList");
//       return keys?.map((e) => e.toString()).toList(growable: false);
//     } else {
//       final keys =
//           await _channel.invokeMethod<List<Object?>>("getCacheKeyList");
//       return keys?.map((e) => e.toString()).toList(growable: false);
//     }
//   }

//   void registerNeedUpdateCursorCallback(NeedUpdateCursorCallback callback) {
//     if (callbacks.contains(callback)) {
//       return;
//     }
//     callbacks.add(callback);
//   }

//   void remoteNeedUpdateCursorCallback(NeedUpdateCursorCallback callback) {
//     callbacks.remove(callback);
//   }

//   /// if one need update cursor, so let's update
//   Future<bool> needUpdateCursor(String? currentKey) async {
//     if (callbacks.isEmpty) {
//       // no registered callback, default is true
//       return true;
//     }
//     final lastKey = await lastCursorKey();
//     for (final cb in callbacks) {
//       bool needUpdate = await cb.call(lastKey, currentKey);
//       if (needUpdate) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

// final customCursorController = FlutterCustomCursorController.instance;
