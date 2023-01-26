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
