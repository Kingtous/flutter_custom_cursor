import Cocoa
import FlutterMacOS

public class FlutterCustomCursorPlugin: NSObject, FlutterPlugin {
    private var caches:Dictionary = [String:NSCursor]();
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_custom_cursor", binaryMessenger: registrar.messenger)
    let instance = FlutterCustomCursorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print(call.method)
    switch call.method {
    case "activateCursor":
        activeCursor(call.arguments as! Dictionary<String,Any>)
        result("ok")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
 
    private func activeCursor(_ arguments: Dictionary<String,Any>) {
        let path = arguments["path"] as! String
        let fullPath = Bundle.main.bundlePath + "/Contents/Frameworks/App.framework/Resources/flutter_assets/" + path
        let cursor = getCursor(named: fullPath)
        cursor?.set()
    }
    
    
    private func getCursor(named path:String) -> NSCursor? {
        var cursor = caches[path]
        if(cursor != nil) {
            return cursor!
        }
        let img = image(named: path)
        if(img == nil) {
            return nil
        }
        cursor = NSCursor.init(image: img!,
                               hotSpot:NSMakePoint(img!.size.width / 2,img!.size.height / 2))
        caches[path] = cursor
        return cursor!
    }
    private func image(named:String) -> NSImage?{
        return NSImage.init(contentsOfFile:"\(named)");
      }

}
