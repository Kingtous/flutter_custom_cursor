import 'package:flutter/services.dart';
import 'package:flutter_custom_cursor/cursor_manager.dart';

Future<void> exerciseNativePlugin() async {
  final png = await rootBundle.load('assets/cursors/data.png');
  final cursor = CursorData()
    ..name = 'ci-custom-cursor'
    ..buffer = png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes)
    ..width = 1
    ..height = 1
    ..hotX = 0
    ..hotY = 0;
  final manager = CursorManager.instance;
  final name = await manager.registerCursor(cursor);
  if (name != cursor.name) throw StateError('Cursor registration failed.');
  try {
    await manager.setSystemCursor(name);
  } finally {
    await manager.deleteCursor(name);
  }
  // A deleted cursor must no longer resolve in the native cache.
  try {
    await manager.setSystemCursor(name);
  } on PlatformException catch (error) {
    if (error.code == '-1') return;
    rethrow;
  }
  throw StateError('Deleted cursor was still available.');
}
