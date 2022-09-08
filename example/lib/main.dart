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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // read memory Cursor
  ByteData data = await rootBundle.load("assets/cursors/mouse.png");
  memoryCursorData = data.buffer.asUint8List();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final path = "/home/kingtous/Downloads/mouse.png";
  String msg = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    customCursorController.registerNeedUpdateCursorCallback(needUpdate);
  }

  @override
  void dispose() {
    customCursorController.remoteNeedUpdateCursorCallback(needUpdate);
    super.dispose();
  }

  Future<bool> needUpdate(String? lastKey, String? currentKey) async {
    return lastKey != currentKey;
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
            cursor: FlutterCustomCursors.getCustomCursor(path),
            child:
                Text("Pencil Style, normally apply to edit mode", style: style),
          ),
          MouseRegion(
            cursor: FlutterCustomCursors.getCustomCursor(path),
            child: Text("Erase Style, normally apply to delete mode",
                style: style),
          ),
          MouseRegion(
            cursor: FlutterCustomCursors.getCustomCursor(path),
            child: Text("CutTop Style, normally apply to delete mode",
                style: style),
          ),
          MouseRegion(
            cursor: FlutterCustomCursors.getCustomCursor(path),
            child: Text("CutLeft Style, normally apply to delete mode",
                style: style),
          ),
          MouseRegion(
            cursor: FlutterCustomCursors.getCustomCursor(path),
            child: Text("CutDown Style, normally apply to delete mode",
                style: style),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text("Flutter Official  Click Cursor", style: style),
          ),
          Row(
            children: [
              MouseRegion(
                cursor: FlutterCustomMemoryImageCursor(
                    pixbuf: memoryCursorData, key: "123"),
                child: Text("123 memory cursor", style: style),
              ),
            ],
          ),
          Row(
            children: [
              MouseRegion(
                cursor: FlutterCustomMemoryImageCursor(
                    pixbuf: memoryCursorData, key: "456"),
                child: Text("456 memory cursor", style: style),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    customCursorController.freeCache("123");
                  },
                  child: Text("clean cache [123]")),
              TextButton(
                  onPressed: () {
                    customCursorController.freeCache("456");
                  },
                  child: Text("clean cache [456]")),
              TextButton(
                  onPressed: () {
                    customCursorController.getCursorCacheKey().then((keys) {
                      setState(() {
                        msg = "caches: ${keys?.toString()}";
                      });
                    });
                  },
                  child: Text("get cursor cache key")),
              TextButton(
                  onPressed: () {
                    customCursorController.lastCursorKey().then((keys) {
                      setState(() {
                        msg = "last cursor key: ${keys?.toString()}";
                      });
                    });
                  },
                  child: Text("get last cursor key"))
            ],
          ),
          Row(
            children: [Text("Response: ${msg}")],
          )
        ],
      )),
    ));
  }
}
