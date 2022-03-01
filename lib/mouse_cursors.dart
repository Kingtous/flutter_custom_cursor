import 'package:flutter/cupertino.dart';

import 'flutter_custom_cursor.dart';

class FlutterCustomCursors  {
  FlutterCustomCursors._();
  static const MouseCursor  pencil =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/pencil.png",x:1,y:15);

  static const MouseCursor  erase =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/erase.png",
      x: 1,
      y: 15
  );
}