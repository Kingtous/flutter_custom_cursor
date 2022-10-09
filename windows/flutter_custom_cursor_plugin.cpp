#include "include/flutter_custom_cursor/flutter_custom_cursor_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace
{

    class FlutterCustomCursorPlugin : public flutter::Plugin
    {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        FlutterCustomCursorPlugin(flutter::PluginRegistrarWindows *registrar);

        // Called for top-level WindowProc delegation.

        std::optional<LRESULT> FlutterCustomCursorPlugin::HandleWindowProc(HWND hWnd,
                                                                           UINT message,
                                                                           WPARAM wParam,
                                                                           LPARAM lParam);

        virtual ~FlutterCustomCursorPlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

        void activate_memory_image_cursor(const flutter::EncodableValue *args);
        int window_proc_id = -1;
        flutter::PluginRegistrarWindows *registrar;
        HCURSOR current_cursor{};
    };

    // static
    void FlutterCustomCursorPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows *registrar)
    {
        auto channel =
            std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                registrar->messenger(), "flutter_custom_cursor",
                &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<FlutterCustomCursorPlugin>(registrar);

        channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto &call, auto result)
            {
                plugin_pointer->HandleMethodCall(call, std::move(result));
            });

        registrar->AddPlugin(std::move(plugin));
    }
    int cnt = 0;
    std::optional<LRESULT> FlutterCustomCursorPlugin::HandleWindowProc(HWND hWnd,
                                                                       UINT message,
                                                                       WPARAM wParam,
                                                                       LPARAM lParam)
    {
        switch (message)
        {
        case WM_SETCURSOR:
            if (LOWORD(lParam) == HTCLIENT)
            {
                SetCursor(this->current_cursor);
                return TRUE;
            }
            break;
        default:
            break;
        }
        return std::nullopt;
    }

    FlutterCustomCursorPlugin::FlutterCustomCursorPlugin(flutter::PluginRegistrarWindows *registrar)
    {
        this->registrar = registrar;
        this->window_proc_id = registrar->RegisterTopLevelWindowProcDelegate(
            [this](HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
            {
                return this->HandleWindowProc(hWnd, message, wParam, lParam);
            });

        this->current_cursor = LoadCursor(NULL, IDC_ARROW);
    }

    FlutterCustomCursorPlugin::~FlutterCustomCursorPlugin()
    {
        this->registrar->UnregisterTopLevelWindowProcDelegate(this->window_proc_id);
    }

#include <cstdio>

    //<String, dynamic>{
    //    'device': device,
    //        'buffer' : cursor.pixbuf,
    //        'length' : cursor.pixbuf.length,
    //        'x' : cursor.hotx ? ? 0.0,
    //        'y' : cursor.hoty ? ? 0.0,
    //        'scale_x' : cursor.imageWidth ? ? -1,
    //        'scale_y' : cursor.imageHeight ? ? -1
    //},
    //);
    void FlutterCustomCursorPlugin::activate_memory_image_cursor(const flutter::EncodableValue *args)
    {
        // if (args == nullptr) {
        //     return;
        // }
        /*auto map = std::get<flutter::EncodableMap>(*args);
        auto buffer = std::get<std::vector<uint8_t>>(map.at(flutter::EncodableValue("buffer")));
        auto scale_x = std::get<int>(map.at(flutter::EncodableValue("scale_x")));
        auto scale_y = std::get<int>(map.at(flutter::EncodableValue("scale_y")));
        auto x = std::get<double>(map.at(flutter::EncodableValue("x")));
        auto y = std::get<double>(map.at(flutter::EncodableValue("y")));
        auto length = std::get<int>(map.at(flutter::EncodableValue("length")));*/
        // load image
        this->current_cursor = ::LoadCursorFromFileA("C:\\Users\\kingtous\\Desktop\\mouse.png");
        ::SetCursor(this->current_cursor);
        std::cout << "activate_memory_image_cursor end" << std::endl;
    }

    void FlutterCustomCursorPlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
    {
        if (method_call.method_name().compare("activateCursor") == 0)
        {
            result->Success(flutter::EncodableValue("ok"));
        }
        else if (method_call.method_name().compare("activateMemoryImageCursor") == 0)
        {
            this->activate_memory_image_cursor(method_call.arguments());
            result->Success();
        }
        else if (method_call.method_name().compare("resetCursor") == 0)
        {
            this->current_cursor = ::LoadCursor(NULL, IDC_ARROW);
            ::SetCursor(this->current_cursor);
            result->Success();
        }
        else
        {
            result->NotImplemented();
        }
    }

} // namespace

void FlutterCustomCursorPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
    FlutterCustomCursorPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
