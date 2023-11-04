import UIKit
import Flutter
import NetworkExtension
import Foundation
import Network
import CoreGraphics
import CoreImage

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "firstMethod":
            result(self.firstMethod())
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func firstMethod() -> Void {}

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
        let channel = FlutterMethodChannel(name: "com.shamilgimbatov.tradingapp/device_info_native", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call, result: result)
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
