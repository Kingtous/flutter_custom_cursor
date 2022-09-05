#ifndef FLUTTER_PLUGIN_FLUTTER_CUSTOM_CURSOR_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_CUSTOM_CURSOR_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_custom_cursor {

class FlutterCustomCursorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterCustomCursorPlugin();

  virtual ~FlutterCustomCursorPlugin();

  // Disallow copy and assign.
  FlutterCustomCursorPlugin(const FlutterCustomCursorPlugin&) = delete;
  FlutterCustomCursorPlugin& operator=(const FlutterCustomCursorPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_custom_cursor

#endif  // FLUTTER_PLUGIN_FLUTTER_CUSTOM_CURSOR_PLUGIN_H_
