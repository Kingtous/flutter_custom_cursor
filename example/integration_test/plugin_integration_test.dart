import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_custom_cursor/cursor_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('macOS cursor create, set, and delete', (tester) async {
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
    expect(name, cursor.name);
    try {
      await manager.setSystemCursor(name);
    } finally {
      await manager.deleteCursor(name);
    }
    // A deleted cursor must no longer resolve in the native cache.
    await expectLater(
      manager.setSystemCursor(name),
      throwsA(
        isA<PlatformException>().having((error) => error.code, 'code', '-1'),
      ),
    );
  }, skip: !Platform.isMacOS);
}
