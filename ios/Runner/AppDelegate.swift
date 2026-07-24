import Flutter
import UIKit
import GoogleMaps  // ← এই লাইনটা যোগ করতে হবে

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // ===== Google Maps API Key বসানোর জায়গা =====
    GMSServices.provideAPIKey("AIzaSyAcfLZs3fXHh91Jds6SzAPCcmFDhhupJGY")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}