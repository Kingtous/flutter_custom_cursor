# flutter_custom_cursor

Customize mouse cursor from Image.

## Platforms

[] macOS
[] Windows
[] Linux

## Getting Started

## Using embeded additional mouse cursors
We're already defined some mmouse cursors on class `FlutterCustomCursors`,just like the stardand class
`SystemMouseCursors`.

### Embed cursors list

* `FlutterCustomCursors.pencil`.
* `FlutterCustomCursors.erase`.
* `FlutterCustomCursors.cut`(TODO)
* `FlutterCustomCursors.merge`(TODO)

```dart
  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body:   Center(
          child: ListView(
            children: const [
              MouseRegion(
                cursor: FlutterCustomCursors.pencil,
                child: Text("Pencil Style, normally apply to edit mode"),
              ),
              MouseRegion(
                cursor: FlutterCustomCursors.erase,
                child: Text("Erase Style, normally apply to delete mode"),
              ),
            ],
          )
      ),
    ),
  );
}
```

# Define you custom cursor

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body:   Center(
          child: ListView(
            children: const [
              MouseRegion(
                cursor: FlutterCustomCursor(path:"assets/cursors/xxx.png"),
                child: Text("cursor from png"),
              ),
            ],
          )
      ),
    ),
  );
}
```






