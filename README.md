# flutter_custom_cursor

Customize mouse cursor from Image.

## Platforms

[] macOS
[] Windows
[] Linux

## Getting Started

```dart
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:  const Center(
          child: MouseRegion(
            cursor: FlutterCustomCursor(path: 'assets/cursors/pencil.png'),
            child: Text("Custom Cursor Here..."),
          ),
        ),
      ),
    );
  }
```


