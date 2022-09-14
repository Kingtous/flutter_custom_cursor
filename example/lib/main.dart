import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_custom_cursor/flutter_custom_cursor.dart';
import 'package:flutter_custom_cursor/mouse_cursors.dart';
import 'dart:ui' as ui;

late Uint8List memoryCursorData;

void main() {
  // read memory Cursor
  final f = File("C:\\Users\\kingtous\\Desktop\\mouse.png");
  memoryCursorData = f.readAsBytesSync();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 30);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: ListView(
          children: [
            MouseRegion(
              cursor: FlutterCustomCursors.pencil,
              child: Text("Pencil Style, normally apply to edit mode",
                  style: style),
            ),
            MouseRegion(
              cursor: FlutterCustomCursors.erase,
              child: Text("Erase Style, normally apply to delete mode",
                  style: style),
            ),
            MouseRegion(
              cursor: FlutterCustomCursors.cutTop,
              child: Text("CutTop Style, normally apply to delete mode",
                  style: style),
            ),
            MouseRegion(
              cursor: FlutterCustomCursors.cutLeft,
              child: Text("CutLeft Style, normally apply to delete mode",
                  style: style),
            ),
            MouseRegion(
              cursor: FlutterCustomCursors.cutDown,
              child: Text("CutDown Style, normally apply to delete mode",
                  style: style),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text("Flutter Official  Click Cursor",
                  style: style),
            ),
            MouseRegion(
              cursor: FlutterCustomMemoryImageCursor(
                pixbuf: memoryCursorData,
                imageHeight: 128,
                imageWidth: 128,
                hotx: 0,
                hoty: 0
              ),
              child: Text("Memory Image Here",
                  style: style),
            ),
          ],
        )),
      ),
    
   );
  }
}
