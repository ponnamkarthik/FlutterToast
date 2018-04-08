import Flutter
import UIKit
    
public class SwiftFluttertoastPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "PonnamKarthik/fluttertoast", binaryMessenger: registrar.messenger())
    let instance = SwiftFluttertoastPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
