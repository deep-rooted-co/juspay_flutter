import Flutter
import UIKit
import HyperSDK

public class SwiftJuspayFlutterPlugin: NSObject, FlutterPlugin {
    private static var CHANNEL_NAME = "juspay"
    private let juspay: FlutterMethodChannel
    private let hyperServices: HyperServices

    init(_ channel: FlutterMethodChannel, _ registrar: FlutterPluginRegistrar) {
        juspay = channel
        hyperServices = HyperServices()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftJuspayFlutterPlugin(channel, registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        switch call.method {
        case "prefetch": prefetch(args["params"] as! [String: Any], result)
        case "initiate": initiate(args["params"] as! [String: Any], result)
        case "process": process(args["params"] as! [String: Any], result)
        case "terminate": terminate(result)
        case "isInitialised": isInitialised(result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func isInitialised(_ result: @escaping FlutterResult) {
        result(hyperServices.isInitialised())
    }

    private func prefetch(_ params: [String: Any], _ result: @escaping FlutterResult) {
        HyperServices.preFetch(params)
        result(true)
    }

    private func initiate(_ params: [String: Any], _ result: @escaping FlutterResult) {
        hyperServices.initiate((UIApplication.shared.keyWindow?.rootViewController)!, payload: params, callback: { (response) in
            if response == nil {
                return
            }
            let event = response!["event"] as? String ?? ""
            if event == "show_loader" {
                self.juspay.invokeMethod("onShowLoader", arguments: "")
            }
            if event == "hide_loader" {
                self.juspay.invokeMethod("onHideLoader", arguments: "")
            }
            if event == "initiate_result" {
                if let jsonData = try? JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        self.juspay.invokeMethod("onInitiateResult", arguments: jsonString)
                    }
                }
            }
            if event == "process_result" {
                if let jsonData = try? JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        self.juspay.invokeMethod("onProcessResult", arguments: jsonString)
                    }
                }
            }
        })
        result(true)
    }

    private func process(_ params: [String: Any], _ result: @escaping FlutterResult) {
        hyperServices.process(params)
        result(true)
    }

    private func terminate(_ result: @escaping FlutterResult) {
        hyperServices.terminate()
        result(true)
    }
}
