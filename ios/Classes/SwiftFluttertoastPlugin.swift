import Flutter
import UIKit
import Toast_Swift
    
public class SwiftFluttertoastPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "PonnamKarthik/fluttertoast", binaryMessenger: registrar.messenger())
    let instance = SwiftFluttertoastPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "showToast":
          result(FlutterMethodNotImplemented)
        default:
          result(FlutterMethodNotImplemented)
    }
  }
}
