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

  static const MouseCursor  cutTop =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/cut_top.png",
      x: 1,
      y: 1
  );

  static const MouseCursor  cutDown =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/cut_bottom.png",
      x: 1,
      y: 15
  );

  static const MouseCursor  cutLeft =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/cut_left.png",
      x: 1,
      y: 8
  );

  static const MouseCursor  cutRight =  FlutterCustomCursor(
      path: "packages/flutter_custom_cursor/assets/cursors/cut_right.png",
      x: 1,
      y: 8
  );

}