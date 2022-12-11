# flutter_custom_cursor

Create/Set a custom mouse cursor from memory buffer.

## Platforms

[x] macOS
[x] Windows
[x] Linux

Note: Currently, the api required by this plugin on Windows is included in flutter `master` branch. It means that u need to use this plugin with flutter master branch on Windows platform. See [flutter engine PR#36143](https://github.com/flutter/engine/pull/36143) for details.


# Get prepared

## Register your custom cursor before

```dart
// register this cursor
cursorName = await CursorManager.instance.registerCursor(CursorData()
  ..name = "test"
  ..buffer =
      Platform.isWindows ? memoryCursorDataRawBGRA : memoryCursorDataRawPNG
  ..height = img.height
  ..width = img.width
  ..hotX = 0
  ..hotY = 0);
```

Note that a String `cacheName` will be returned by the function `registerCursor`, which can be used to set this cursor to system or delete this cursor.

`CursorData.buffer` is a `Uint8List` which contains the cursor data. Be aware that on Windows, `buffer` is formatted by `rawBGRA`, other OS(s) are `rawPNG`.

see the example project for details.

## Set the custom cursor

We have implemented the `FlutterCustomMemoryImageCursor` class, which is a subclass of `MouseCursor`. This class will automatically set the memory cursor for you. Keep it simple.

```dart
MouseRegion(
  cursor: FlutterCustomMemoryImageCursor(key: cursorName),
  child: Row(
    children: [
      Text("Memory image here", style: style),
    ],
  ),
),
```

## Delete the cursor 

You can delete a cursor with the `cursorName`.

```dart
await CursorManager.instance.deleteCursor("cursorName");
```
