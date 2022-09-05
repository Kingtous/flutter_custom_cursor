#include "include/flutter_custom_cursor/flutter_custom_cursor_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_custom_cursor_plugin.h"

void FlutterCustomCursorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_custom_cursor::FlutterCustomCursorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
