import Cocoa
import FlutterMacOS

public class FlutterCustomCursorPlugin: NSObject, FlutterPlugin {
  private var caches: Dictionary = [String: NSCursor]();
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_custom_cursor", binaryMessenger: registrar.messenger)
    let instance = FlutterCustomCursorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "createCustomCursor":
        let arguments = call.arguments as! Dictionary<String, Any>
        let ret = createCustomCursor(arguments)
        if (ret == nil) {
            result(FlutterError(code: "-1", message: "Create the cursor failed", details: "Please make sure a png buffer is provided."))
        } else {
            result(ret!)
        }
        break
    case "setCustomCursor":
        let arguments = call.arguments as! Dictionary<String, Any>
        let ret = setCustomCursor(arguments)
        if ret {
            result(nil)
        } else {
            result(FlutterError(code: "-1", message: "Set the cursor failed", details: "Did you create this cursor called this name before?"))
        }
        break
    case "deleteCustomCursor":
        let arguments = call.arguments as! Dictionary<String, Any>
        let _ = deleteCustomCursor(arguments)
        result(nil)
        break
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func createCustomCursor(_ arguments: Dictionary<String, Any>) -> String? {
    let name = arguments["name"] as! String
    let buffer = [UInt8]((arguments["buffer"] as! FlutterStandardTypedData).data)
    let hotX = arguments["hotX"] as! Double
    let hotY = arguments["hotY"] as! Double
    // no need to provide width and height on macOS API
    let _ = arguments["width"] as! Int
    let _ = arguments["height"] as! Int
    let image = memoryImage(data: Data(buffer))
    if (image == nil) {
        return nil;
    }
    let cursor = getCursor(image: image!, x: hotX, y: hotY)
    caches[name] = cursor;
    return name
  }
    
  private func setCustomCursor(_ arguments: Dictionary<String,Any>) -> Bool {
    let name = arguments["name"] as! String
    let cursor = caches[name];
    if (cursor == nil) {
        return false
    }
    cursor!.set()
    return true
  }
    
  private func deleteCustomCursor(_ arguments: Dictionary<String,Any>) -> Bool {
    let name = arguments["name"] as! String
    let cursor = caches[name];
    if (cursor == nil) {
        return false
    }
    caches.removeValue(forKey: name)
    return true
  }
    
    private func activateMemoryImageCursor(_ arguments: Dictionary<String,Any>) {
        let buffer = arguments["buffer"] as! FlutterStandardTypedData
        let byte = [UInt8](buffer.data);
        var image = memoryImage(data: Data(byte))
        if (image == nil) {
            return
        }
        // TODO: no scale on macOS currently
        if (arguments["scale_x"] as! Int != -1) {
            image = resize(image: image!, w: arguments["scale_x"] as! Int, h: arguments["scale_y"] as! Int)
        }
        let cursor = getCursor(image: image!, x: arguments["x"] as? Double, y: arguments["y"] as? Double)
        cursor.set()
    }
 
    private func activeCursor(_ arguments: Dictionary<String,Any>) {
        let path = arguments["path"] as! String
        let fullPath = Bundle.main.bundlePath + "/Contents/Frameworks/App.framework/Resources/flutter_assets/" + path
        let cursor = getCursor(path:fullPath,
                               x:arguments["x"] as? Double,
                               y:arguments["y"] as? Double)
        cursor?.set()
    }
    
    private func resize(image: NSImage, w: Int, h: Int) -> NSImage {
//        var destSize = NSMakeSize(CGFloat(w), CGFloat(h))
//        var newImage = NSImage(size: destSize)
//        newImage.lockFocus()
//        image.drawInRect(NSMakeRect(0, 0, destSize.width, destSize.height), fromRect: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.CompositeSourceOver, fraction: CGFloat(1))
//        newImage.unlockFocus()
//        newImage.size = destSize
        return image
    }
    
    
    private func getCursor(path:String,x:Double?,y:Double?) -> NSCursor? {
        var cursor = caches[path]
        if(cursor != nil) {
            return cursor!
        }
        let img = image(named: path)
        if(img == nil) {
            return nil
        }
        cursor = getCursor(image: img!, x: x, y: y)
        caches[path] = cursor
        return cursor!
    }
    
    private func getCursor(image: NSImage,x:Double?,y:Double?) -> NSCursor {
        var dx = x;
        var dy = y;
        if(dx == nil) {
            dx = Double(image.size.width) / 2;
        }
        if(dy == nil) {
            dy = Double(image.size.height) / 2;
        }
        let cursor = NSCursor.init(image: image,
                               hotSpot:NSMakePoint(CGFloat(dx!),CGFloat(dy!)))
        return cursor
    }
    
    private func image(named:String) -> NSImage?{
        return NSImage.init(contentsOfFile:"\(named)");
    }
    
    private func memoryImage(data: Data) -> NSImage? {
        return NSImage.init(data: data)
    }
}
